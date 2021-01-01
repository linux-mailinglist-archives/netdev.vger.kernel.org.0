Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522462E82BD
	for <lists+netdev@lfdr.de>; Fri,  1 Jan 2021 02:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbhAABBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 20:01:53 -0500
Received: from mr85p00im-zteg06011601.me.com ([17.58.23.186]:60563 "EHLO
        mr85p00im-zteg06011601.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbhAABBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 20:01:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1609462857;
        bh=IdVuwkwHcNAMoC/b9ScHSlyLISHJ/sGNhu2fYhEGCp8=;
        h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To;
        b=bvhzVHmN6U6xzZEUbnZ6GmrmGhprxVQnQlG3EO940+dnec5LG79c6sRtYDM1gUHIZ
         AS3OEYfZb9q8LujSqHSF2MkwxifFyLUcSVawu89TYAV5JZ3eC+VwcFabYPrENVa+sC
         /TyKSmWPQNZqJ6uQxmjCTWUDdAxWh7Epbm2mOCSEE3ctz6GHumY1OMuyMmMA6f6mV0
         DJVCT+fxMGgdfFXElycjrR04syZKfm8SiGdlMBJHrveStZwIicGY+2PdGcgVP8oZFY
         3EB7eDYzEORZZ66kuRsK/5ORMzM+LoEXPxGXwMIp8p/ECXES+eFZ5wdeujiWstzzt2
         2VxFY51hRfBHw==
Received: from tbodt-pro.attlocal.net (99-130-36-163.lightspeed.frokca.sbcglobal.net [99.130.36.163])
        by mr85p00im-zteg06011601.me.com (Postfix) with ESMTPSA id DF801920504
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 01:00:57 +0000 (UTC)
From:   Theodore Dubois <tblodt@icloud.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: What's the difference between inet_rcv_saddr and inet_saddr?
Message-Id: <D183BBDD-9FF2-4097-A91D-C535B6BEE1D3@icloud.com>
Date:   Thu, 31 Dec 2020 17:00:57 -0800
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-31_13:2020-12-31,2020-12-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=318 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2006250000 definitions=main-2101010002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Resending since my first attempt appears to have gone to /dev/null)

What's the difference between inet_rcv_saddr and inet_saddr? Or inet_num =
and inet_sport.

It seems that the first of each pair is in the struct sock instead of =
the struct inet_sock, but that doesn't explain why there would be =
apparent duplicates of each in the inet_sock.

Thanks,
~Theodore

