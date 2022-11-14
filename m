Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C0462793E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbiKNJlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbiKNJlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:41:24 -0500
X-Greylist: delayed 405 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Nov 2022 01:41:22 PST
Received: from relay.mgdcloud.pe (relay.mgdcloud.pe [201.234.116.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE45C1AF1E
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:41:21 -0800 (PST)
Received: from relay.mgdcloud.pe (localhost.localdomain [127.0.0.1])
        by relay.mgdcloud.pe (Proxmox) with ESMTP id 458A2229901;
        Mon, 14 Nov 2022 04:34:32 -0500 (-05)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cgracephoto.com;
         h=cc:content-description:content-transfer-encoding:content-type
        :content-type:date:from:from:message-id:mime-version:reply-to
        :reply-to:subject:subject:to:to; s=Relay; bh=POmmLhbs6/14Mhmcbsw
        HpX0H+MIlo+W0e6cG8XDkBG8=; b=FYFu2xXvFkzjGejQ/UD5Jifb4Pw8s92WmbU
        QU+1LDkbBZDwTzA/v0BE3ZUkoaC7ImMOySla0eQzXzr0XhdyOfNHQ6/PbbQLVAlq
        AjKOk69xp7S5tvGI6uOWg300LnQEAb2PkHwOPQDQOUAgW1xep6jKK8Lz4PyqlKJb
        gXrneV2Na54SxzGS0KXbNoGvMFPgNgOkkxku5uNvD/qs9qPW0CjNz2jMiA9JZ1fu
        HyaLAbfIwPtkKv2TublRNdbaPhZWT5xuvj67Jg9IFN0CKNFskk8VWucz0oaYgoKL
        MJYFG787l025BuKNjwODzKzBFJ9lUiuhc8NQZ/N5EdhH48B9OhA==
Received: from portal.mgd.pe (portal.mgd.pe [107.1.2.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by relay.mgdcloud.pe (Proxmox) with ESMTPS id 2D30C229027;
        Mon, 14 Nov 2022 04:34:32 -0500 (-05)
Received: from localhost (localhost [127.0.0.1])
        by portal.mgd.pe (Postfix) with ESMTP id 0F57420187D81;
        Mon, 14 Nov 2022 04:34:32 -0500 (-05)
Received: from portal.mgd.pe ([127.0.0.1])
        by localhost (portal.mgd.pe [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 7JSs882beyQV; Mon, 14 Nov 2022 04:34:31 -0500 (-05)
Received: from localhost (localhost [127.0.0.1])
        by portal.mgd.pe (Postfix) with ESMTP id B8A5320187D83;
        Mon, 14 Nov 2022 04:34:31 -0500 (-05)
X-Virus-Scanned: amavisd-new at mgd.pe
Received: from portal.mgd.pe ([127.0.0.1])
        by localhost (portal.mgd.pe [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dOFRVytk0HFv; Mon, 14 Nov 2022 04:34:31 -0500 (-05)
Received: from [103.125.190.179] (unknown [103.125.190.179])
        by portal.mgd.pe (Postfix) with ESMTPSA id 28B0E20187D81;
        Mon, 14 Nov 2022 04:34:24 -0500 (-05)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Strategic plan
To:     Recipients <cindy@cgracephoto.com>
From:   "Mr.IgorS. Lvovich" <cindy@cgracephoto.com>
Date:   Mon, 14 Nov 2022 01:34:23 -0800
Reply-To: richad.tang@yahoo.com.hk
Message-Id: <20221114093425.28B0E20187D81@portal.mgd.pe>
X-Spam-Status: Yes, score=6.4 required=5.0 tests=BAYES_95,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_REPLYTO,HK_NAME_MR_MRS,RCVD_IN_SBL,
        SPF_FAIL,SPF_HELO_PASS,TO_EQ_FM_DOM_SPF_FAIL,TO_EQ_FM_SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9751]
        *  0.1 RCVD_IN_SBL RBL: Received via a relay in Spamhaus SBL
        *      [103.125.190.179 listed in zen.spamhaus.org]
        *  0.0 SPF_FAIL SPF: sender does not match SPF record (fail)
        *      [SPF failed: Please see http://www.openspf.org/Why?s=mfrom;id=cindy%40cgracephoto.com;ip=201.234.116.20;r=lindbergh.monkeyblade.net]
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  1.0 HK_NAME_MR_MRS No description available.
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
        *  0.0 TO_EQ_FM_SPF_FAIL To == From and external SPF failed
        *  0.0 TO_EQ_FM_DOM_SPF_FAIL To domain == From domain and external SPF
        *       failed
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello
I will like to use the liberty of this medium to inform you as a consultant=
,that my principal is interested in investing his bond/funds as a silent bu=
siness partner in your company.Taking into proper
consideration the Return on Investment(ROI) based on a ten (10) year strate=
gic plan.
I shall give you details when you reply.

Regards,

