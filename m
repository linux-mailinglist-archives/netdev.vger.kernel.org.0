Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03C557B231
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbiGTH6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiGTH6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:58:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A5461105;
        Wed, 20 Jul 2022 00:58:16 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26K7tpuw027033;
        Wed, 20 Jul 2022 07:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=BbjUISBoD0CbZtVa4qw0rQlzFN0Qz3MAGgfCW4CptDg=;
 b=jnpGZa/V7z3KqJHAubfiNZFs32FCqfXnVMG3TvIkfnOFPEpY/CBYNdtsNj+U11SwshgK
 pybdnLzuPv/8aDHp9MWLP/ZPmQqsf9Pue+9FvJuSU/jCiKKYjUPD+5JZK+PLVU+K/++i
 wfs3Ye2eShVuGlHZyKq7GV6/nXYdCkmtzuGN2jbbcEZHZDRIt5NJ1At2e8vE2N4laUJb
 4/O9EZAqjUaLaiqP4fpAhMAItaEoq+4BRdNyM7StZcLa8iKYwCeK6W1nwtaMw2/6mZfz
 W1euqHUDvn4z82G4/ey/4NvBsMh8eteWkhNBaFE7d7kz1Z0T29R2nPwz7c4/qJd+3OEa 3g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hedrh0274-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 07:58:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26K7oknW027301;
        Wed, 20 Jul 2022 07:58:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8w9ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 07:58:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26K7w65E23659006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 07:58:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0470A4040;
        Wed, 20 Jul 2022 07:58:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40183A4053;
        Wed, 20 Jul 2022 07:58:06 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.22.197])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 20 Jul 2022 07:58:06 +0000 (GMT)
Date:   Wed, 20 Jul 2022 09:58:04 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     svens@linux.ibm.com, wintera@linux.ibm.com, wenjia@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/net: Fix comment typo
Message-ID: <Yte1jKAX4j3Jvdix@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20220716042700.39915-1-wangborong@cdjrlc.com>
 <Ytb1/uU+jlcI4jXw@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytb1/uU+jlcI4jXw@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iGOsWayD2oenUNCGgfhp4LElpPTwmcGJ
X-Proofpoint-ORIG-GUID: iGOsWayD2oenUNCGgfhp4LElpPTwmcGJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_04,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=658
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207200031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:20:48PM +0200, Alexander Gordeev wrote:
> Applied, thanks!

Please, ignore this one!
