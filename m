Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206FA4348E5
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhJTK3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:29:46 -0400
Received: from smtpout2.vodafonemail.de ([145.253.239.133]:33612 "EHLO
        smtpout2.vodafonemail.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhJTK3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 06:29:45 -0400
Received: from smtp.vodafone.de (unknown [10.2.0.32])
        by smtpout2.vodafonemail.de (Postfix) with ESMTP id 88997121B2B
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 12:27:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
        s=vfde-smtpout-mb-15sep; t=1634725649;
        bh=k+nluSbK1OeJge7Q+CaUfgIawIwIWjkJpIT5CBl4GaU=;
        h=From:To:Date:Subject:Reply-to;
        b=nPKFVE2LpQtpPHrkwQPnBtqVVP/T2cVqgfcKY9IxRc9UdTNEW2YOkii29okH1e0jI
         aUDKEqbXqRjhpv4ot0tOhuSxGfJod4F2CdWDRDaiXDv9q/SGJXmdU2esJl8pgE7Q9B
         /1/CKic7mfA+9ASDhw+UC+4bz//YzjfZOzgWn+MQ=
Received: from [192.168.1.30] (unknown [77.64.170.60])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id A413C14019C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 10:27:28 +0000 (UTC)
From:   "Dieter Ferdinand" <dieter_ferdinand@nexgo.de>
To:     netdev@vger.kernel.org
Date:   Wed, 20 Oct 2021 12:27:27 +1
MIME-Version: 1.0
Subject: ip route bug
Reply-to: Dieter.Ferdinand@gmx.de
Message-ID: <616FEF0F.7162.76AE04@dieter_ferdinand.nexgo.de>
X-mailer: Pegasus Mail for Windows (4.63, DE v4.63 R1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-purgate-size: 456
X-purgate-ID: 155817::1634725648-0000065C-326BD13E/0/0
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

