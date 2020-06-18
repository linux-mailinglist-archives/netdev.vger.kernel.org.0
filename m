Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90841FED39
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgFRIJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbgFRIGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:06:33 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBE2C061755
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:06:32 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id q19so5411750eja.7
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jdqKWoOyO8tnt8jM6tOGRLXKdHHuxGrW259cHQOP1hQ=;
        b=Bl68elqdqcLd30G17pvoe9exM0NJ8hGF7jB5cGALBgvffL4Hs4vGUKFwalT6qPJxtx
         aN0oLBEu2Bslk9VDAdZ1c9MJn4xMHVUPPwi6RqIWall7j+JeZaDNq/J/EN2gjWCwy8qC
         cBLJ6ske6QcdjduiZEMSUCX3LU3ylAdfULiUv3PIl976LvSQB6ZzuQACNqqumUqqgWTk
         3vhZGYzvsXzvPPJANR/hs3aYPzHfozkXVPFSpI0P4jkCsJWPftzC8Po+fIxoZ2G3M806
         OCvyRN8Ia/EjRPB2BwMcDt0XUdLekkm3HReRFNdmKXDemdcnOTOECUjY9ZYmEsgWtb32
         +v3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jdqKWoOyO8tnt8jM6tOGRLXKdHHuxGrW259cHQOP1hQ=;
        b=F2KcQPPLZvw1AKXs1bvOtECNq4cGCi9BSRKWsgFj5ISZBK7SBG6SsR4JE4rk1t/846
         1uVXwa3c3aoQQekhtpPMl5h7Iptgil2+2sHrKMN1eF+AyyGOCaUBNhVnJpKoLJJavn5/
         dLAqdU1hOX4lq7S8gHr7lcvWFvxqcJ1Qme3SNPY28Ucy4+FnSdFVNFPg0jvNuIX9A7J2
         AgrjDYoPyoqemf+o3+L6F6tooeelS6LzKE3q1IPBXBSauwuRGIVa4OsmvfOlZORlPv4X
         YVGWhYOL+3MrQAb0/ghMJ3qEerlUGPwWOQup5ZLyck4MvWIjvRNwemXvhNjvHc6xLqkb
         qjgQ==
X-Gm-Message-State: AOAM532V+wmoaQDGOuFHkK8TH5ZZsNqhdoxpqxGJH1HtfMdVbQ+gL2D/
        O38F7sO712FVXo2x+zmewLMGGw==
X-Google-Smtp-Source: ABdhPJwl82oiSxnfYLXazps1x+rq+d4v0E9PMnXQgh6ZFurD6BCgfQLUMtmWbYQrxHGMPNn408CItw==
X-Received: by 2002:a17:906:4d18:: with SMTP id r24mr2781366eju.222.1592467590896;
        Thu, 18 Jun 2020 01:06:30 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id nw22sm1711739ejb.48.2020.06.18.01.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 01:06:30 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] add MP_PRIO, MP_FAIL and MP_FASTCLOSE
 suboptions handling
To:     Geliang Tang <geliangtang@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <cover.1592289629.git.geliangtang@gmail.com>
 <04ae76d9-231a-de8e-ad33-1e4e80bb314c@tessares.net>
 <20200618062737.GA21303@OptiPlex>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <8397397f-d341-0593-9ba9-a87f1d63c26b@tessares.net>
Date:   Thu, 18 Jun 2020 10:06:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200618062737.GA21303@OptiPlex>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 18/06/2020 08:27, Geliang Tang wrote:
> On Tue, Jun 16, 2020 at 05:18:56PM +0200, Matthieu Baerts wrote:
>> On 16/06/2020 08:47, Geliang Tang wrote:
 >>
>> I would suggest you to discuss about that on MPTCP mailing list. We also
>> have meetings every Thursday. New devs are always welcome to contribute to
>> new features and bug-fixes!
 >
> Thanks for your reply. I will do these tests and improve my patches.

Great, thank you! Looking forward to see new kernel selftests and/or 
packetdrill tests!

For any new features related to MPTCP or bug fixes involving significant 
code modifications, please send it first to the MPTCP Upstream mailing 
list only: mptcp@lists.01.org

We will be able to give a first review without involving the whole 
netdev community and if needed, we can "park" patches in our mptcp-next 
repo.

For more details about the project, please check: 
https://github.com/multipath-tcp/mptcp_net-next/wiki

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
