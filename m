Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A26410CE2
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 20:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhISS2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 14:28:11 -0400
Received: from imsva.erbakan.edu.tr ([95.183.198.89]:35424 "EHLO
        imsva.erbakan.edu.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhISS2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 14:28:10 -0400
X-Greylist: delayed 1433 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Sep 2021 14:28:10 EDT
Received: from imsva.erbakan.edu.tr (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0046D124A00;
        Sun, 19 Sep 2021 20:54:54 +0300 (+03)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=erbakan.edu.tr;
        s=dkim; t=1632074094;
        bh=GF0kCZVzMAbL+zC2eGZ6bprg0BK693Z+UfWbMwtUgEs=; h=Date:From:To;
        b=tERvpswE0hDLQmheCApqRjkMGAiiBduPF5/NZDQ3NnlJy6/YHgKYqG1CAbAEtqygt
         Xd+2KpNQ5jY4JAXc//axi3zo3tDjePY7uN7jt6aRaVkb7DB4nU3O+pseaHvCVkCp3u
         nSjkfSaHq1oAsQN6KgVA4Dt3vJEkCls67TRTKR7g=
Received: from imsva.erbakan.edu.tr (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E17E91249FD;
        Sun, 19 Sep 2021 20:54:53 +0300 (+03)
Received: from eposta.erbakan.edu.tr (unknown [172.42.40.30])
        by imsva.erbakan.edu.tr (Postfix) with ESMTPS;
        Sun, 19 Sep 2021 20:54:53 +0300 (+03)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by eposta.erbakan.edu.tr (Postfix) with ESMTP id 168861217BB77;
        Sun, 19 Sep 2021 21:02:47 +0300 (+03)
Received: from eposta.erbakan.edu.tr ([127.0.0.1])
        by localhost (eposta.erbakan.edu.tr [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id VKR8s4R_7Z6R; Sun, 19 Sep 2021 21:02:47 +0300 (+03)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by eposta.erbakan.edu.tr (Postfix) with ESMTP id 89F251217BB58;
        Sun, 19 Sep 2021 21:02:46 +0300 (+03)
DKIM-Filter: OpenDKIM Filter v2.10.3 eposta.erbakan.edu.tr 89F251217BB58
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=erbakan.edu.tr;
        s=9A114B22-0D17-11E9-AE7D-5CB170D0BDE7; t=1632074567;
        bh=UE+6Rh6p+D/Q/qnCC1rilRTfAwcozVy4J0wYoa1QJws=;
        h=Date:From:Message-ID:MIME-Version;
        b=E8NDvWw5w//+3rb+gQEM61zGwnwNbPwanciplKuLw/AcTULygNmYJxQeTaNh/fzo1
         mKv84RDwxy4vu401WyNIcV23xrTt2Pqz3wZBvsP5ym5Th/RlenJYt42cRRSKJTOgct
         pIOnhIgJdqTb0IYO9l3NAvZQH0lKVrBXUJ5h56Q+ORisvFJ0evRSSfhACZCDFn7UTa
         lmGCaEr/w/W9DJ0a9B97vxPyz/qFAUikpnsXi96XBB3qeW3m1YVOXaXYwGUw3vE9nn
         XH7McwMJz+e1dwvtsTsmpKmIZp6m7u0yBElbyQLToA3saIi9YzSzaJGZJuKwdMHoUZ
         fPKSMmRh+sWgg==
X-Virus-Scanned: amavisd-new at eposta.erbakan.edu.tr
Received: from eposta.erbakan.edu.tr ([127.0.0.1])
        by localhost (eposta.erbakan.edu.tr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UXnWUy3F6Y7P; Sun, 19 Sep 2021 21:02:45 +0300 (+03)
Received: from eposta.erbakan.edu.tr (eposta.konya.edu.tr [172.42.44.72])
        by eposta.erbakan.edu.tr (Postfix) with ESMTP id 513491217BB06;
        Sun, 19 Sep 2021 21:02:45 +0300 (+03)
Date:   Sun, 19 Sep 2021 21:02:44 +0300 (EET)
From:   =?utf-8?B?eWFyxLHFn21h?= gsf <yarismagsf@erbakan.edu.tr>
Reply-To: =?utf-8?B?eWFyxLHFn21h?= gsf <oasisportfb@gmail.com>
Message-ID: <1393078619.525573.1632074564836.JavaMail.zimbra@erbakan.edu.tr>
Subject: Re: Instant approval
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.11_GA_3799 (ZimbraWebClient - GC92 (Win)/8.8.11_GA_3787)
Thread-Index: Ss03EdyvqVI5U9XEzN3p4ScB4lzn6g==
Thread-Topic: Instant approval
To:     undisclosed-recipients:;
X-TM-AS-GCONF: 00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oasis is offering quick loans, without credit check to old and new customers. We give Short or long term loan with a relatively low interest rate of about 0.2% on Instant approval.
Oasis Fintech a onetime solution to all your financial need.
Contact us today via email, oasisportfb@gmail.com,  and complete the loan form below....
Your Full Name:
Amount Required:
Contact Phone #:
Occupation:
Loan Duration:
Purpose:
Location:
 
Ms. Bauer
Contact us via: email:  oasisportfb@gmail.com
