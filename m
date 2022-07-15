Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222E05760F9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiGOL6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiGOL6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:58:44 -0400
X-Greylist: delayed 909 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 04:58:39 PDT
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4670C2610
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 04:58:38 -0700 (PDT)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.17.1.5/8.17.1.5) with ESMTP id 26F8ZgBI009981;
        Fri, 15 Jul 2022 12:43:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=jan2016.eng;
 bh=Bsv+xHM+H7Kfuv3dsDfrrF2366OAp2YNX8FCFeagh4U=;
 b=HHX+aLMGSHLR8k54/Az2ynax7sshYkzIqqpfHwWI8iA4svkvjxa58gVfvbOoswQ5imVP
 c4wPq9QeP9o4+oYJ4yrAR1yhvraDNcV4/NzBGkptfBZc1YY/J2DtnamsXeIxVelj5AsR
 dd1EmFJuwpfBoleu7RbvB7ckF1GFNlsFk104sT0EWmOiEexaSc3mF5Jya7X5xfQklSAN
 pLTW9HsRuaFhffZjGTP5TdxeiAlAeM8gCRjkmPxNaoLtMlpW7gpD7kvsPOESs6JyI6yy
 mFZQnOwtxQr4e4oWQKqwOqVX/bveYZ4Q+OzdeuceTjxMyGHzRns53QlF9fNb6p0/xfsG fQ== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050102.ppops.net-00190b01. (PPS) with ESMTPS id 3habgf4mdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 12:43:27 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 26FAR1I3009844;
        Fri, 15 Jul 2022 04:43:27 -0700
Received: from email.msg.corp.akamai.com ([172.27.123.34])
        by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3h77nay13c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 04:43:27 -0700
Received: from localhost (172.27.118.139) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Fri, 15 Jul 2022 07:43:26 -0400
Date:   Fri, 15 Jul 2022 12:43:23 +0100
From:   Max Tottenham <mtottenh@akamai.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <johunt@akamai.com>
Subject: Re: [PATCH iproute2-next] tc: Add JSON output to tc-class
Message-ID: <20220715114323.xx7dc4oneoxpryjj@lon-mp1s1>
References: <20220408105447.hk7n4p5m4r6npzyh@lon-mp1s1.lan>
 <20220408084254.72ab9b50@hermes.local>
 <20220519163600.zxbxvmxw37m57wm7@lon-mp1s1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220519163600.zxbxvmxw37m57wm7@lon-mp1s1>
X-Originating-IP: [172.27.118.139]
X-ClientProxiedBy: usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_03,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=762 mlxscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207150050
X-Proofpoint-GUID: C_NC_m9SR1WmeAGrjIPf3MWysp5Xwbp0
X-Proofpoint-ORIG-GUID: C_NC_m9SR1WmeAGrjIPf3MWysp5Xwbp0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_03,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 lowpriorityscore=0 impostorscore=0 phishscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=728 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207150051
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/19, Max Tottenham wrote:
> On 04/08, Stephen Hemminger wrote:
> > On Fri, 8 Apr 2022 11:54:47 +0100
> > Max Tottenham <mtottenh@akamai.com> wrote:
> > 
> > >   * Add JSON formatted output to the `tc class show ...` command.
> > >   * Add JSON formatted output for the htb qdisc classes.
> > > 
> > > Signed-off-by: Max Tottenham <mtottenh@akamai.com>
> > 
> > LGTM, if there no objections will pick it up for this release.
> 
> Just checking back in on this, I don't see it in the 'next' tree for
> iproute2 yet.
> 
> Cheers
> 
> - Max

Hi Stephen

Circling back on this again. Would you like me to resend the patchset?

Cheers

- Max

-- 
Max Tottenham | Senior Software Engineer
/(* Akamai Technologies
