Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E94C3A4B
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 01:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbiBYAXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 19:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiBYAXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 19:23:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1854181E7C;
        Thu, 24 Feb 2022 16:22:47 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P040um005357;
        Fri, 25 Feb 2022 00:22:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=e37v2GGU0I/ORobayoE//gNcdIQqEbFUPLKvwzSTUcs=;
 b=ToxcDVZYs1RBgdqKn5XErLBdgZhyajrqeHlttLi1QTukmwFv1MsDb0lpPVfkE4ZYF8sK
 ojf0DildiscwC+C1fKnzJwIr883uSI9eEJYGKn2lgFzHBAZ8RtkTphXhgAXVSK39R15p
 231cr3R9pBcPeV0cSxrkxBE6BG94busD2VXLNDNiIvrkxxAXAeUO3GVsAlRxyMsjjljf
 DV08QllHvVuOxDtRpd/NGIc/HM2wWvKORczqfVgGSOKWYFjFlRY84tiGO4zNEe8Vrr8d
 q/M+DW47yTvSkK9ZYw8gXs/xbnGOvQXs4EE7jiEKMQ/JVDtGzjOEFk75zFbEnv6LTSU0 Ow== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edwkex1gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 00:22:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21P0C64p032409;
        Fri, 25 Feb 2022 00:22:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear69n2vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 00:22:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21P0MJrp54854090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 00:22:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34C2452050;
        Fri, 25 Feb 2022 00:22:19 +0000 (GMT)
Received: from sig-9-65-86-89.ibm.com (unknown [9.65.86.89])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9D81B5204E;
        Fri, 25 Feb 2022 00:22:17 +0000 (GMT)
Message-ID: <408a96085814b2578486b2859e63ff906f5e5876.camel@linux.ibm.com>
Subject: Re: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kpsingh@kernel.org, revest@chromium.org
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 24 Feb 2022 19:22:17 -0500
In-Reply-To: <20220215124042.186506-1-roberto.sassu@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hA114obf-THotzvqlZ7wCVGc3u1_A-VZ
X-Proofpoint-ORIG-GUID: hA114obf-THotzvqlZ7wCVGc3u1_A-VZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_06,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=821 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roberto,

On Tue, 2022-02-15 at 13:40 +0100, Roberto Sassu wrote:
> Extend the interoperability with IMA, to give wider flexibility for the
> implementation of integrity-focused LSMs based on eBPF.

I've previously requested adding eBPF module measurements and signature
verification support in IMA.  There seemed to be some interest, but
nothing has been posted.

thanks,

Mimi

