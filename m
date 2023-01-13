Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CDD66A10A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 18:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjAMRrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 12:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjAMRrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 12:47:12 -0500
X-Greylist: delayed 1202 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 13 Jan 2023 09:35:50 PST
Received: from mail.dmbarone.com (mail.dmbarone.com [5.181.144.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39602974AE;
        Fri, 13 Jan 2023 09:35:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.dmbarone.com (Postfix) with ESMTP id F1FA92A5FF8;
        Fri, 13 Jan 2023 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dmbarone.com; s=mail;
        t=1673629302; bh=QIjTgWBPcZMVeqZovj8WAOWgI9bu1lFe9hdim3iQkyQ=;
        h=Subject:To:From:Date:Reply-To:From;
        b=1iTq7Rzmq2icj14k5a0zdbMjXwEZd5YIDAy9Obv5RYTeLjg1+WmdR2nG4uN+teRc+
         6DL53NnNDaZ8/rGze6HUjuD3Tmqkx0s5xw8KGAz94GjxWzjTCz69pR8qWCDV29avwZ
         ayggOMY46ZkMkVCgibGSrGOc5bqe+p4y/un8W99c=
X-Virus-Scanned: Debian amavisd-new at ispdmbarone.kubeitalia.it
Received: from mail.dmbarone.com ([127.0.0.1])
        by localhost (ispdmbarone.kubeitalia.it [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id iC9iFSeHXW7I; Fri, 13 Jan 2023 17:01:41 +0000 (UTC)
Received: from [172.20.10.6] (unknown [129.205.124.225])
        (Authenticated sender: admin@dmbarone.com)
        by mail.dmbarone.com (Postfix) with ESMTPSA id B4E222A601D;
        Fri, 13 Jan 2023 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dmbarone.com; s=mail;
        t=1673629301; bh=QIjTgWBPcZMVeqZovj8WAOWgI9bu1lFe9hdim3iQkyQ=;
        h=Subject:To:From:Date:Reply-To:From;
        b=kuKiHLBg5RrcqKGPmbFJyYg5EweeVW2uIJxebPF6TyQPKbBRD2Ihs1YxawFXuaWtP
         lgekszO6mMszOc2wrdwhOtsrRBwBzsArlG43n1UkuicfB/oFliybeU1xgkBJNuwqxE
         r2klWP1QCO3mQGfs8REUb8ie/cD5vvm/j83U+6r0=
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?q?Wohlt=C3=A4tigkeit!!?=
To:     Recipients <admi@dmbarone.com>
From:   <admi@dmbarone.com>
Date:   Fri, 13 Jan 2023 18:01:38 +0100
Reply-To: theresasteven225@gmail.com
X-Antivirus: Avast (VPS 230113-2, 1/13/2023), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20230113170141.F1FA92A5FF8@mail.dmbarone.com>
X-Spam-Status: Yes, score=6.6 required=5.0 tests=BAYES_95,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_SBL,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9617]
        *  0.1 RCVD_IN_SBL RBL: Received via a relay in Spamhaus SBL
        *      [129.205.124.225 listed in zen.spamhaus.org]
        *  1.3 RCVD_IN_VALIDITY_RPBL RBL: Relay in Validity RPBL,
        *      https://senderscore.org/blocklistlookup/
        *      [5.181.144.66 listed in bl.score.senderscore.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [theresasteven225[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eine Spende wurde an Sie get=E4tigt, antworten Sie f=FCr weitere Einzelheit=
en.

Gr=FC=DFe
Theresia Steven

-- 
This email has been checked for viruses by Avast antivirus software.
www.avast.com
