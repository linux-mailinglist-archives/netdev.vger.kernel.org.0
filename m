Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0FB576E01
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 14:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiGPMos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 08:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGPMor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 08:44:47 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1F41FCCA;
        Sat, 16 Jul 2022 05:44:46 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 2DEEAC01D; Sat, 16 Jul 2022 14:44:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657975485; bh=IA4QPpfoiFnQ2zfDlGVbxad+iB79l2GmGj2fr9NMdbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G0uAyt4wTJPwOceVj+tlHrPj+xmBFviQ7X72SyBqhVvgLf0Vq68vGLIIDf6wGXHpv
         /ZoOJrTDJ/7Blr/3hNrEUTHLHuxb6tTD1oYo8LbV1YmKnk3onzxQ66NJe//OyrfuQv
         0AQf7Kri+WDki7x02bSb8nUbNMHAMedqQX8y+qSsL3SeSu/z1XecxwH39UGDC5l1zU
         wjsCW0VEeD3bkxcIO0tbLGva8SwAYSUiyXzVLp+NXCxzP7arfxRS/3ttAOW+noskG+
         DmHYsL8U+iRGezh0eAytTnlufMGiOUo4SaizZE/4yoyZW8VLqeSQL5RhExfZoGvirN
         7VQ7QSgT6Se5w==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 6FD49C009;
        Sat, 16 Jul 2022 14:44:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657975484; bh=IA4QPpfoiFnQ2zfDlGVbxad+iB79l2GmGj2fr9NMdbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tZk+QlpZgl3gWazkAqaUwVdiv4ez3fRI+jeHGHtsI3erIAIMwdA1jmZx0ebHfbWVU
         1aaY/JAS2JZxpjfcFKv2fJZ/TAfJC+BQzWw9ZaSyvSV87MkX5KMbR2Ix2hSrRQ0y0N
         ahAxOvyFc8X+Blr3uZfPBQwYVgsZ6M51BORkdeLkWuxpfa2o8X/nzKuiIwSMEjAPv/
         bKfltFQLMLeKaKoiFv58lsooYIFQcb1NPSK7SgJ8bAzXEmtAWkIMiz0wIEJjcevcTZ
         Cpwyj2Naba4imZ5BnXZtnHiWM2OiOXFvOzH7EaYHkiJUCjzup7BBaEYS8iBlJZNGsX
         oo7aT4BxhUpUg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 0e23bbef;
        Sat, 16 Jul 2022 12:44:39 +0000 (UTC)
Date:   Sat, 16 Jul 2022 21:44:24 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v6 00/11] remove msize limit in virtio transport
Message-ID: <YtKyqPx/FX1BbDqW@codewreck.org>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
 <6713865.4mp09fW1HV@silver>
 <YtKm4M8W+rL+buNj@codewreck.org>
 <4065120.gss6piHCF5@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4065120.gss6piHCF5@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Sat, Jul 16, 2022 at 02:10:05PM +0200:
> > OTOH, linux got softiwarp merged in as RDMA_SIW which works perfectly
> > with my rdma applications, after fixing/working around a couple of bugs
> > on the server I'm getting hangs that I can't reproduce with debug on
> > current master so this isn't exactly great, not sure where it goes
> > wrong :|
> > At least with debug still enabled I'm not getting any new hang with your
> > patches, so let's call it ok...?
> 
> Well, I would need more info to judge or resolve that, like which patch 
> exactly broke RDMA behaviour for you?

I wouldn't have troubles if I knew that, I don't have access to the
hardware I last used 9p/rdma on so it might very well be a softiwarp
compatibility problem, server version, or anything else.

At the very least I'm not getting new errors and the server does receive
everyhing we sent, so as far as these patches are concerned I don't
think we're making anything worse.


I'll get back to you once I hear back from former employer (if they can
have someone run some tests, confirm it works and/or bisect that), I
really spent too much time trying to get the old adapter I got working
already...

All I can say is that there's no error anywhere, I've finally reproduced
it once with debug and I can confirm the server sent the reply and
didn't get any error in ibv_post_send() so the message should have been
sent, but the client just never processed it.
Next step would be to add/enable some logs on the client see if it
actually received something or not and go from there, but I'd like to
see something that works first...

--
Dominique
