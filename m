Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61F76132D
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 01:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfGFXHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 19:07:01 -0400
Received: from avasout07.plus.net ([84.93.230.235]:35742 "EHLO
        avasout07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfGFXHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 19:07:00 -0400
Received: from Ultrabook1 ([81.174.172.105])
        by smtp with ESMTPA
        id jtlihfwhZljKgjtljh4aJN; Sun, 07 Jul 2019 00:06:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plus.com; s=042019;
        t=1562454420; bh=X6tnLuhP2GtNDny84NocORC/8sxCsog5VCE0V+7wGJw=;
        h=From:To:Subject:Date;
        b=ZwGnTmFnA/IOKagO+4bD3TUYsWknEyVoBdyWfKY6BxKTLlCQrjV3qXxHVcvxBU4r9
         3hRLNKKzgcsdYcGrlqYcfwrhCdz6o+MdL6AG9XgI+0E+GEroMz6Jo1DkqrOIun7Gdx
         V1SLVA5VtMYFUQcLokPSvlVzlT6vJXhPyC47LIxVryu+s4oSHooanKjDEnQMKPmdNV
         ZLTasMcOXeMYyh6fAHjdiPkfNA/y2dsd6HR0KSNTWkRuUo71F0CFIs6ie8XkZCsTKe
         +Nd2GZy/XtWngM0eTJetOy4LOwgJiYBtecqG0R1XDmvyRQn8Y6o0nKg/iAtdugmBmS
         6Bsh61qTl+S7g==
X-Clacks-Overhead: "GNU Terry Pratchett"
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.3 cv=ermhMbhX c=1 sm=1 tr=0
 a=Cgy7cPM/+uUNK5d9KfAcsw==:117 a=Cgy7cPM/+uUNK5d9KfAcsw==:17
 a=8nJEP1OIZ-IA:10 a=NdwDdLHFcajMHM5En7EA:9 a=wPNLvfGTeEIA:10
 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
X-AUTH: moeller@:2500
Message-ID: <AFAC77AC6F8347289E6900614A523B32@Ultrabook1>
From:   "Markus Moeller" <huaraz@moeller.plus.com>
To:     <netdev@vger.kernel.org>
Subject: More complex PBR rules
Date:   Sun, 7 Jul 2019 00:06:58 +0100
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 16.4.3528.331
X-MimeOLE: Produced By Microsoft MimeOLE V16.4.3528.331
X-CMAE-Envelope: MS4wfEhdhhyTwpvmHxf6GtB5Hn4L7sxk4fmUnOpbmJcOsH1WSa+iKWQEvpW1Go4xAcrro16PdRfjjAt8S/raLoJ8ejZOLheOFAVL+6YZhIsBHfuPh51IybOz
 c9IsGEw7KUEtrkIG8RYJrrxjRGR/0PL4ffVxsmjOXVyPURPH2oem4KjbftkFz68UOD83Esg1LJX6SA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Network developers

I am new to this group and wonder if you can advise how I could implement 
more complex PBR rules to achieve for example load balancing. The 
requirement I have is to route based on e.g. a hash like:

  hash(src-ip+dst-ip) mod N  routes via  gwX    0<X<=N   ( load balance over 
N gateways )

  This would help in situations where I can not use a MAC for identifying a 
gateway  ( e.g. in cloud environments) .

   Could someone point me to the kernel source code where PBR is performed ?

Thank you
Markus 


