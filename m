Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDA052DACD
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbiESRGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbiESRGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:06:12 -0400
X-Greylist: delayed 1786 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 10:06:11 PDT
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EE523155
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 10:06:10 -0700 (PDT)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.17.1.5/8.17.1.5) with ESMTP id 24JEDPTM030761;
        Thu, 19 May 2022 17:36:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=jan2016.eng;
 bh=c7KOZrEUXH42iEY6WtkyVsYwoXmQP78trvXKCUcfM+Q=;
 b=cpMEJCgn0+cvs4pCpJzJyz+r7haxaGnyvynSPp88IC59RCPYOo8qF41Vp+1lgFOkYLjS
 a082j+MP5crjthQkigFqr9HUZSUDokoLKuhat2JkjMSeyYiCrr2WCjzb/76Ey/wBIxyS
 PYBRLjC5MURDeOtxNiujYpU701yhWhjtM/AQKcnorped41FPsOtd3Co76OXQkPjmtfmO
 JpF6wgt+Fu2Mc8rOm95YVFXtERfzRwmZIkIlZeLySAI6dc1lrCQgoDlb+r1kS0M4ZDzL
 VMzTMGKTdaHYnJlvIvHVQFIZFcTQQeEfc0kUGhv38qMGuUtAM6s4081BVQszVv0uaz2A zA== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by m0050102.ppops.net-00190b01. (PPS) with ESMTPS id 3g5668wq83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 17:36:23 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.1.2/8.16.1.2) with SMTP id 24JGaNgV027963;
        Thu, 19 May 2022 12:36:23 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.23])
        by prod-mail-ppoint2.akamai.com with ESMTP id 3g27rygx96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 12:36:23 -0400
Received: from usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59) by
 usma1ex-dag4mb2.msg.corp.akamai.com (172.27.91.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.22; Thu, 19 May 2022 12:36:22 -0400
Received: from localhost (172.27.118.139) by
 usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Thu, 19 May 2022 12:36:22 -0400
Date:   Thu, 19 May 2022 17:36:15 +0100
From:   Max Tottenham <mtottenh@akamai.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <johunt@akamai.com>
Subject: Re: [PATCH iproute2-next] tc: Add JSON output to tc-class
Message-ID: <20220519163600.zxbxvmxw37m57wm7@lon-mp1s1>
References: <20220408105447.hk7n4p5m4r6npzyh@lon-mp1s1.lan>
 <20220408084254.72ab9b50@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220408084254.72ab9b50@hermes.local>
X-Originating-IP: [172.27.118.139]
X-ClientProxiedBy: usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) To
 usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_05:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=767 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190095
X-Proofpoint-ORIG-GUID: EU0-kG7c9oh8vfjzc7rwG9b5FnL9T2lC
X-Proofpoint-GUID: EU0-kG7c9oh8vfjzc7rwG9b5FnL9T2lC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_05,2022-05-19_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=785 clxscore=1011 mlxscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190095
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/08, Stephen Hemminger wrote:
> On Fri, 8 Apr 2022 11:54:47 +0100
> Max Tottenham <mtottenh@akamai.com> wrote:
>=20
> >   * Add JSON formatted output to the `tc class show ...` command.
> >   * Add JSON formatted output for the htb qdisc classes.
> >=20
> > Signed-off-by: Max Tottenham <mtottenh@akamai.com>
>=20
> LGTM, if there no objections will pick it up for this release.

Just checking back in on this, I don't see it in the 'next' tree for
iproute2 yet.

Cheers

- Max

--=20
Max Tottenham | Senior Software Engineer
/(* Akamai Technologies
