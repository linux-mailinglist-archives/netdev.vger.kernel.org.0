Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560623BE29
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389858AbfFJVNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:13:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37614 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfFJVNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:13:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id 20so5684465pgr.4
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=xX0ywrril08ISuPqfnuEKb66JjCpwcFjDRF4EiiPKDM=;
        b=KkrNzUcAOGaMqeJGnloWq7KHk0l+ov4rfXCyyGbmdMYfAYSx7p98VF1auCArV4MKvG
         anYqbd1pXZzRm4zmTWAG65GAydGAiZyLTOuf8HyBULr1bm57adZ6vg+yTFN3Wrs6fZDL
         +Fzs15jH9n3tYwgjjD9nm/LJd093dXfIeaMsGw0o8RG2mlzt9zcayQaS2gPvrVrHeocV
         ZSMN3+cABvI2TRlgYiN/D/w4YvOIayRxtRm4fAyzmlHbVwbbWlXDKTaN5N7MdPvU3rgS
         P1GzALdALa9nk8RvJaBgTV7EbqWRQOdlreq+C2LIKXbOinOlHmqlo/hdjU70G43K9NAL
         3X8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xX0ywrril08ISuPqfnuEKb66JjCpwcFjDRF4EiiPKDM=;
        b=C5/xVpdnEQSzy77A0upHPbWwxYfAiddN79O+CkR7/bQJPVI0+LsfHeIqAYrkte+ohO
         07nog71uEmLoymXnyBro3ibvOPF9w3uCae0PV6bPtaOEDN6tz6eUwl0xQZCacNC03qT5
         lMlH8Vx49aRQlmx4Hp1X+8JMyQ/B3igpcYkWVwYHkHJQ41PT7W9fEm7AmCkJzgZEEwdp
         MkWaregcupKF5xIUyyt6o+8j+9f6u1XPjhMlbR6KhJZ3KTsLobDVPKZBZARzE4Xsjb8A
         QQJf1Yan4PgNEWQzPeetOp+Lotn04TJrjnDKYHJEKfFEMAAc9rpi8aNfm7lZg9H11A2f
         apVA==
X-Gm-Message-State: APjAAAWPFYwOtUmb253aNARWb/sMmdejdYRkpwQD+r27sQCDfPtMEzlt
        ch7emmBS1yWQMhbrmYZZhf0=
X-Google-Smtp-Source: APXvYqxC47a9K/m1wkQI+86iObYfv4VsoiNTGXokvZesCmmjQy32qolmD3D4fBzBQ73KvmxJNfLFzg==
X-Received: by 2002:a17:90a:1a0d:: with SMTP id 13mr17744164pjk.99.1560201224983;
        Mon, 10 Jun 2019 14:13:44 -0700 (PDT)
Received: from [192.168.0.16] (97-115-113-19.ptld.qwest.net. [97.115.113.19])
        by smtp.gmail.com with ESMTPSA id 137sm14506417pfz.116.2019.06.10.14.13.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 14:13:44 -0700 (PDT)
Subject: Re: [ovs-dev] [PATCH net-next] net: openvswitch: remove unnecessary
 ASSERT_OVSL in ovs_vport_del()
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
References: <20190609171906.30314-1-ap420073@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <f2af0857-2352-9478-6f9d-87b0c1381454@gmail.com>
Date:   Mon, 10 Jun 2019 14:13:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609171906.30314-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/9/2019 10:19 AM, Taehee Yoo wrote:
> ASSERT_OVSL() in ovs_vport_del() is unnecessary because
> ovs_vport_del() is only called by ovs_dp_detach_port() and
> ovs_dp_detach_port() calls ASSERT_OVSL() too.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   net/openvswitch/vport.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 258ce3b7b452..9e71f1a601a9 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -261,8 +261,6 @@ int ovs_vport_set_options(struct vport *vport, struct nlattr *options)
>    */
>   void ovs_vport_del(struct vport *vport)
>   {
> -	ASSERT_OVSL();
> -
>   	hlist_del_rcu(&vport->hash_node);
>   	module_put(vport->ops->owner);
>   	vport->ops->destroy(vport);

LGTM
Reviewed-by: Greg Rose <gvrose8192@gmail.com>
