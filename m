Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6FF4348E6
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhJTK3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:29:47 -0400
Received: from smtpout2.vodafonemail.de ([145.253.239.133]:33620 "EHLO
        smtpout2.vodafonemail.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhJTK3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 06:29:46 -0400
Received: from smtp.vodafone.de (unknown [10.2.0.32])
        by smtpout2.vodafonemail.de (Postfix) with ESMTP id 58B81121BC2
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 12:27:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arcor.de;
        s=vfde-smtpout-mb-15sep; t=1634725650;
        bh=k+nluSbK1OeJge7Q+CaUfgIawIwIWjkJpIT5CBl4GaU=;
        h=From:To:Date:Subject:Reply-to;
        b=JUR9JNNtZ8DrjKuh4vNBUdUEo8q4NMkkvxZiRRQ+uLHl2YZfFRAv5Ns83ibHp26J8
         1msgUZQV7s3Au/I+gps02MLDlZIBhr4YhT75ll/pjWZCjnINdTkeZuKIx3q8RGfosN
         VDvoxYDkdW/mEoFpeQoxLsFyVvYd2v1PUKHX5FKI=
Received: from [192.168.1.30] (unknown [77.64.170.60])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id EB3ED1401A0
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 10:27:29 +0000 (UTC)
From:   "Dieter Ferdinand" <dieter.ferdinand@arcor.de>
To:     netdev@vger.kernel.org
Date:   Wed, 20 Oct 2021 12:26:41 +1
MIME-Version: 1.0
Subject: ip route bug
Reply-to: Dieter.Ferdinand@gmx.de
Message-ID: <616FEEE1.23605.75F96A@dieter.ferdinand.arcor.de>
X-mailer: Pegasus Mail for Windows (4.63, DE v4.63 R1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-purgate-size: 456
X-purgate-ID: 155817::1634725650-0000065C-73E7FB77/0/0
X-Spam: Yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,
i have a problem with ip route add default via ip. i get the message, that this entry 
already exists, but i can add it with route add default gw ip.

it is right, that this entry exist, but it exist for an other routing table for source-routing, 
but not for the default routing table.

goodby


Schau auch einmal auf meine Homepage (http://privat.dieter-ferdinand.de).
Dort findest du Information zu Linux, Novell, Win95, WinNT, ...

