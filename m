Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4E81784D3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 22:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732587AbgCCVYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 16:24:39 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33159 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732580AbgCCVYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 16:24:38 -0500
Received: by mail-pg1-f195.google.com with SMTP id m5so2153928pgg.0
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 13:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=NtNUtnN9Ero6yIBS/stLNoWouEtHDt6oLkEk7DC0xPU=;
        b=Cfd08no1QVAM/QJuNEvmuL+SWP2cUCqIRvy1/qBuy2G+l8hMvsRcqDCIOurnl3MEpE
         ZieEklL31DQZ86LibQpzu5pHwlIuS7Sf5asJ0DgvHlzsOTjRqjWFdVUUwwnx5fEPngB3
         XjthsZ4usXSNJHeyW0HEmp/1RnzFq00zj/I4X+njpDMOjIEslzOFpul1pfvcFXDEYTU7
         CU524nuR4z8e3NgJQcrN5PFx3NWsjliPN2b2W26xQUAd6ucLRy6v0ltAk3ikhwURKbEE
         LjN7MaDvJnqubUQBkPt5lUYWX1ZohG4zPrpsZNT0qi/Y+RX+fCBT5jNFHYTpYbeB2R8U
         PtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NtNUtnN9Ero6yIBS/stLNoWouEtHDt6oLkEk7DC0xPU=;
        b=XzwsxIuY7cRC3kAkujmPbSFPhEP+EhGfq4AJFGazmg8cvlyMZiE5AC8/q1VBaiL+yc
         YHiTYIlj9tra13E1c8pnBWntdFxwzRvdobhHpHgGnZ+H105fhGqU5kDSaqm5QFrc455e
         UucRpKfp95Umy+2Oa0cU7+DmtgBxKocqc9+PybClSCcYKBl8apqMRgj2W85w89xwkgHh
         eMYRedzpfN2+bONrAOyOmc9Ed4mHWcQ0N1N1IlaapF8UE2rL2YC4xtFhUDXKxYwRPoSp
         DMpTX6KY71apdfwhLGZmbquq0L9w+woJ5I7iP8c4/kACb9F5ETj81i2ZC43N56SkShLO
         YfyQ==
X-Gm-Message-State: ANhLgQ1PH17WEnZFUBHxkuqV/qJL6jSn4y0D/05IH5LNQrhXdtZYuVvU
        4RBkoidhoGDet/FbXWe8JpXhgzLKPj4=
X-Google-Smtp-Source: ADFU+vtQgUrjuXCOn2B86btgPPncN7fPYULm+Az6XIdapxwRWceEXaQIYCIk4lWFAUjV9TAvUUHQKQ==
X-Received: by 2002:a63:30c4:: with SMTP id w187mr5972294pgw.239.1583270677576;
        Tue, 03 Mar 2020 13:24:37 -0800 (PST)
Received: from [192.168.0.16] (97-115-106-43.ptld.qwest.net. [97.115.106.43])
        by smtp.gmail.com with ESMTPSA id o12sm13164489pfp.1.2020.03.03.13.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 13:24:36 -0800 (PST)
Subject: Re: [ovs-dev] [PATCH net 08/16] openvswitch: add missing attribute
 validation for hash
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     dev@openvswitch.org, netdev@vger.kernel.org
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-9-kuba@kernel.org>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <01310a75-ca5e-3583-4c1f-fd3aa05e86d9@gmail.com>
Date:   Tue, 3 Mar 2020 13:24:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303050526.4088735-9-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/2/2020 9:05 PM, Jakub Kicinski wrote:
> Add missing attribute validation for OVS_PACKET_ATTR_HASH
> to the netlink policy.
>
> Fixes: bd1903b7c459 ("net: openvswitch: add hash info to upcall")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: Pravin B Shelar <pshelar@ovn.org>
> CC: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> CC: dev@openvswitch.org
> ---
>   net/openvswitch/datapath.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c047afd12116..07a7dd185995 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -645,6 +645,7 @@ static const struct nla_policy packet_policy[OVS_PACKET_ATTR_MAX + 1] = {
>   	[OVS_PACKET_ATTR_ACTIONS] = { .type = NLA_NESTED },
>   	[OVS_PACKET_ATTR_PROBE] = { .type = NLA_FLAG },
>   	[OVS_PACKET_ATTR_MRU] = { .type = NLA_U16 },
> +	[OVS_PACKET_ATTR_HASH] = { .type = NLA_U64 },
>   };
>   
>   static const struct genl_ops dp_packet_genl_ops[] = {

LGTM

Reviewed-by: Greg Rose <gvrose8192@gmail.com>

