Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6992E82BC
	for <lists+netdev@lfdr.de>; Fri,  1 Jan 2021 02:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbhAAA6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 19:58:41 -0500
Received: from mr85p00im-ztdg06021801.me.com ([17.58.23.195]:33781 "EHLO
        mr85p00im-ztdg06021801.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbhAAA6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 19:58:41 -0500
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Dec 2020 19:58:41 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1609462084;
        bh=5meQJsXXvqtUjjl1/nXz2cyZL1LLrB3+9pq5jrLuIYg=;
        h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To;
        b=wJ/kyRMnHui25vmQvk0JY/96lBdVPAyPTM9opVCEB1Qeis1SIn+uHpjmqHO7iyuf3
         srU6rnX8ycY/mDKOUFM9CfLFOV5yTGK65YMX+KhLQxl+9oRaOGsfuIUT2qyiKU9HLI
         ZBD7H1PQV9NFG+prFogBOiRVTm4Y/uGCZr5EdQEAgc5YOAdmQCJt7l3wFXx9l60Bid
         OKpv//PE1oC1PPHAjgAB2nvDLfOoNYU9Hkp02HPB22B6d6XKSf5vphVNkk8n3Iuvbz
         gVZkVfK8xSBba+iKzj7Me6RTA8DEfe5+M/L9MhyjX+DAhUkW097SGSyDpst1TYs+Xr
         RcBzYWXuEMYRQ==
Received: from tbodt-pro.attlocal.net (99-130-36-163.lightspeed.frokca.sbcglobal.net [99.130.36.163])
        by mr85p00im-ztdg06021801.me.com (Postfix) with ESMTPSA id 75BC61804FA
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 00:48:04 +0000 (UTC)
From:   Theodore Dubois <tblodt@icloud.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: What's the difference between inet_rcv_saddr and inet_saddr?
Message-Id: <99D89C0B-7651-419E-9ACB-9DED6DD17CF0@icloud.com>
Date:   Thu, 31 Dec 2020 16:48:03 -0800
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-31_13:2020-12-31,2020-12-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=377 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2006250000 definitions=main-2101010001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What's the difference between inet_rcv_saddr and inet_saddr? Or inet_num =
and inet_sport.

It seems that the first of each pair is in the struct sock instead of =
the struct inet_sock, but that doesn't explain why there would be =
apparent duplicates of each in the inet_sock.

Thanks,
~Theodore

