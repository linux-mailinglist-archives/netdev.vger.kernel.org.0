Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185AD59309
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 06:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfF1Ex6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 00:53:58 -0400
Received: from mail-pf1-f229.google.com ([209.85.210.229]:42798 "EHLO
        mail-pf1-f229.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfF1Ex5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 00:53:57 -0400
Received: by mail-pf1-f229.google.com with SMTP id q10so2324111pff.9
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 21:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ctcd-edu.20150623.gappssmtp.com; s=20150623;
        h=from:subject:thread-topic:thread-index:date:message-id
         :accept-language:content-language:content-transfer-encoding
         :mime-version;
        bh=uja0RKLj8/ZClYB7/xee4WJU8BS3tEVS8HkeIEY1v6o=;
        b=Pp6ugwMblAVk8EdSg2uZmnwCkjDnAeUEtYkyl/2pd63LjuHbk2LC1q+xge5CQIC/GH
         pNJGwVNnOYcmjYXoYf2oan/rFHg6jNqjzfTJF61crDfC7ANiGAwRM8eGWxPOMRhAUQyg
         lvdfAI0FfcjnvflgOXPvcA6EYs2cbKrmPfHb1o4wQKeSph2+crg4HdF4tb7L54XcZta/
         /fnDZjiJQb5VzkHj3lI0XB3f129ALqpevx0mKDb5YpjTfAqrLwH+19+2nC7YgxGKaPst
         vrV+q9eb+0yRY8GkmSrqDs/6aTIyTKO1scCH0BR7nb5KP/AyjnoZR+d5eS80Idxrzoet
         bK/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:thread-topic:thread-index:date
         :message-id:accept-language:content-language
         :content-transfer-encoding:mime-version;
        bh=uja0RKLj8/ZClYB7/xee4WJU8BS3tEVS8HkeIEY1v6o=;
        b=bLGOgZx0DexBdcegmjlWjHa1Qn7WHW6Pv0tYmULHkTQpNfPC7F6/hVaTgDZQm0s2i9
         1KeS7u5uvqVf/O899h3OYwrZPBB7JzhewTY0GS783UukxqIehFF7at1zqSrzTWRHTadB
         bJsP/FWsznm+xNmMF/dMnI16BwT1x8LO6syK6y/eDZWfPrGePbsoYSUKy3Yk13A/l0dN
         QU8FbPgMJOGMW4JTf/ZfDceqL6A1k6uZ89dPoM1zGFUtO4+mi6hZLXHU2vM4QT94HqZi
         ilYRJZ3wiKlzLiE+W5Nz7c2rOBc9CkMzdT+gBikqZl8zYHh3h2gdVhEolKe0NrPGj7LK
         3/7Q==
X-Gm-Message-State: APjAAAV3Tr0g2c8lR0g1RD0VLvb48KDzj8gOj8LFUOPkrjao5IgAIMsF
        S6EUPhAt7oH50j7o3h6fmnzQnNclGgEzIVG2B+6molGazVhqfA==
X-Google-Smtp-Source: APXvYqyDOfZDdbFJ4o/JaxBjQfLRRMqZEDtH+CcFi8WIpV2AIUfzPQ1HX/vVf+o0DsKm/s5gVaROJ/mA9eje
X-Received: by 2002:a17:90a:cb18:: with SMTP id z24mr10369284pjt.108.1561697634618;
        Thu, 27 Jun 2019 21:53:54 -0700 (PDT)
Received: from mail.ctcd.edu (rrcs-67-79-90-89.sw.biz.rr.com. [67.79.90.89])
        by smtp-relay.gmail.com with ESMTPS id n69sm110753pjb.9.2019.06.27.21.53.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 21:53:54 -0700 (PDT)
X-Relaying-Domain: ctcd.edu
Received: from CTCEmail02.campus.ctcd.org (172.17.139.89) by
 CTCEmail01.campus.ctcd.org (172.17.139.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.845.34; Thu, 20 Jun 2019 09:18:40 -0500
Received: from CTCEmail02.campus.ctcd.org ([fe80::a0bb:ad1f:8c21:8800]) by
 CTCEmail02.campus.ctcd.org ([fe80::a0bb:ad1f:8c21:8800%2]) with mapi id
 15.01.0845.034; Thu, 20 Jun 2019 09:18:40 -0500
From:   "Chambers, Marcine" <MChambers@ctcd.edu>
Subject: GOOD DAY
Thread-Topic: GOOD DAY
Thread-Index: AQHVJ3MOz3fw4vybV0CezupQuoA3uw==
Date:   Thu, 20 Jun 2019 14:18:40 +0000
Message-ID: <6406a540a0c54cb4900afa0f5889c847@ctcd.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.17.139.254]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Vice Chairman of Hang Seng Bank, I have Important Matter to Discuss wi=
th you concerning my late client, Died without a NEXT OF KIN. Send me your =
private email for full details information. email me at (chienkraymond@outl=
ook.com)

Mail:infocarfer@aim.com

Regards
Dr.Raymond Chien Kuo Fung

