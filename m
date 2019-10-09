Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0916CD1396
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731417AbfJIQIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:08:21 -0400
Received: from sonic309-14.consmr.mail.bf2.yahoo.com ([74.6.129.124]:34674
        "EHLO sonic309-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731226AbfJIQIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:08:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1570637299; bh=dRX5d8v++xfAAoPIT3VpAbTnk4dfpHOyQKhLrN2OBJk=; h=Date:From:Reply-To:Subject:From:Subject; b=rZTRxZkRS7AK4jeaLvaBUgPPVZj/vY83objC+PGaz+jDaENUFTzdsOeD8NOHmmtvVHzYPhv6NfX2knSBhsGVaZt6ffTBizpNuPRpZf5a5NncGUE3xBmfnmSD/prd+5tGWWHcRs71Z4Q4g/34kxSg4kvhGc+bLEoqVv5v7qiMZQ8h90gxqpQjmIbflBoOCkuo22binZqk2pJEXYvTooLft/IOnwyKfN0P6PZgY4aLZ6AFMYAvl8WnPCUwBkUqnidhLOWlQ9W+qxYfIL02TBCDlgEarqGtwVg51I2ztmfzEffj4kUirP/f/K1TBFgf+9Tm9Qh3fuLXTSxATsa67WxEog==
X-YMail-OSG: e6W.Y.YVM1lMJpdVESh.3A4EmV6hQZMFHbBgQZxxieGewcvaMa4o5l2fgo7.Tep
 9tBET9L9DwTPcpCDsiW2LvQypVv4iH48uto2Ev7MTQcPrc9orNptggOJi8AI_O8hpNWMRRCAlEBP
 JVLoM.2.4DPt97sReDrgN0jMuM6Vy0946LmEffZ8xNuklLFRg9JPBQhwvfHEvYYjMWOOqK53pRIM
 mdW9ckG_hEqLppRhxNETzJzOWjnVOvopP.QTssfeXhKZZNck2g_6cByv8thK2SetcMvaaEYyz68A
 9g8_oCJ6E0G4Ep7Pai9kjP35ZOluQAfyqf7rWC7fXRlIhL8pVeYRZmQQfiEHtnlItSMLgtx5xjUH
 cIqlh3Y1hBL5VSFfTc4WAkAUNnDzjcYc1OIVdDx.b27px5KuEghqFtERNf_wy9ekwdftDUEy_1t1
 cHhQRdEYhLn.S7O9_aXLQNOuxCaYjOroG3a.WFR5jL4I2dM54IYjFu3.AqDJ2cV0Q4DE8vb0l2uA
 Q_zv3ysAi7TgzIaLPgOVkKsVWwgnN7O_anELY2WwxeK1BBpa_ApuzEYgCCLQKQJGAXWtF4uztJld
 cWOqgeJlfXVhbi1rQspXKSQPVzqpxp3drVDr.OJFlTAqpIGaO9IYZE9cJVrYmwcOAuiRXXgh5Rdb
 xvIeR6nECyNPFQ9fznbrk29uP.fvA4Q5vnnjkMuPxWt57iYjsf6b.UjFzDvT5AMC_uHwuZHvyiF0
 f76LFVUhZYRqjtqmbXm82bF.89fMn24TGbf28o1Vf5t3OmAtoD9VQJ1nJGfjXlGZu67.VgQYGoYi
 VGJ9evCKg8zoYLBSe0YfkAs6YXQC4.kc5lEBek.oMbj9EAblOXnAG_.8FcEUmNfeCBYPu9jvPHPn
 IlVMN5dEzC3cKYfeqlxxcdRzPmjiWNL7fVND2gUbd5HcdRRxdR5F8O5DBhGGNRDF7CVSx27tym6m
 ViWwmLvyRIRsK0PqctU2pVJxxLhcNyWBWSIzdiQCf73dDtJPvWeqCBK2qZ.ezT5o0hHkL191hn65
 he4LluMlh8gM2CX2hHEMtAk7pnZaRT3MQQLJyokxEDODzCGOh1gHIwGimL9FMsn8akSq3WNI6V3U
 Pgm_dU46F..WOIeahSECXLt6s7Bb9v_H7sHQqmPrArRL4ohxOSfTHKWfg5WUr1fqpEjRRHQVemJk
 ecFfh8MG8LzyQERaWr1AfZ8qEr6TUzu2aFg4ISyBQqd4RThK3.iyruaeqE2_XZ9r4k4kx28hmA7B
 pU8KmMfuAiflQNC9OuQqwx49NEr.NIUdC3aR.xroxgWcdYdCDelLXuA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Wed, 9 Oct 2019 16:08:19 +0000
Date:   Wed, 9 Oct 2019 16:08:15 +0000 (UTC)
From:   Miss Abibatu Ali <abibatuali01@gmail.com>
Reply-To: abibatu22ali@gmail.com
Message-ID: <58902439.249726.1570637295036@mail.yahoo.com>
Subject: Hello
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello
I'm "Mrs.Abibatu Ali" married to Mr. Ali ( an International Contractor and Oil Merchant/ jointly in Exposition of Agro  Equipment ) who died in  Burkina Faso attack,  i am 64 years old and diagnosed of cancer for about 2 years ago  and my husband informed me that he deposited the sum of (17.3Million USD Only) with a Finance house) in  UAGADOUGOU BURKINA FASO.

I want you to help me to use this money  for a charity project before I die, for the Poor, Less-privileged and  ORPHANAGES in
your country.  Please kindly respond

quickly for further details.

Yours fairly friend,
Mrs. Abibatu Ali 
