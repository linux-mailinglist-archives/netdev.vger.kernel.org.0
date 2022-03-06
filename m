Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18CA4CED6B
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 20:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiCFT0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 14:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiCFT0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 14:26:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0798F61A23;
        Sun,  6 Mar 2022 11:25:22 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 226FYM11026530;
        Sun, 6 Mar 2022 19:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=O2vubwyRWRHE+0xjcWAfyV7bruPoI7ZRIqLPKOfBRBI=;
 b=NnQ7RWen/citxH41hkPP8wlRlXMcfzq4w1P+WCZSzYHCeQx5w5umhX/9FxoeUxCDbT91
 Ac0ckHKFiuqjiO0YIzSjXFN51i3hdqLurol1HQa/ETm7TrYQZADXMR+5su6UMEV8PpXF
 G31s1QTwd05OWit4oFD9Y+ocTIBh9mUCuGQvZzklYo6bcCbfNa5E+RloA9QmyQMKxkAK
 zUZ4+Ij6ggDJOK/CAM5LvJmZoiMoSYNjayNHK1hQjwWwR7bjrr6AL0yea1x6y/JKFndI
 /wSdsrvvFAjzRd24KnyeNiWb6mVG0rzI51n9PkOloLKyXPJM00ZmsGOkcIHbjt1lBcvw NA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3emsrppb4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 19:25:03 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 226JMtwj002083;
        Sun, 6 Mar 2022 19:25:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3ekyg92hw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 19:25:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 226JOws049086838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Mar 2022 19:24:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A80D111C04C;
        Sun,  6 Mar 2022 19:24:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE85611C04A;
        Sun,  6 Mar 2022 19:24:56 +0000 (GMT)
Received: from sig-9-65-93-47.ibm.com (unknown [9.65.93.47])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  6 Mar 2022 19:24:56 +0000 (GMT)
Message-ID: <8e18392eb849682cf0906ca9180c763ac8e70adc.camel@linux.ibm.com>
Subject: Re: [PATCH v3 1/9] ima: Fix documentation-related warnings in
 ima_main.c
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, revest@chromium.org,
        gregkh@linuxfoundation.org
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
Date:   Sun, 06 Mar 2022 14:24:56 -0500
In-Reply-To: <20220302111404.193900-2-roberto.sassu@huawei.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
         <20220302111404.193900-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rZGtAGrUfsVKB4Sv1FxGZw4YIKqEw1I_
X-Proofpoint-GUID: rZGtAGrUfsVKB4Sv1FxGZw4YIKqEw1I_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-06_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1011 suspectscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203060130
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-03-02 at 12:13 +0100, Roberto Sassu wrote:
> Fix the following warnings in ima_main.c, displayed with W=n make argument:
> 
> security/integrity/ima/ima_main.c:432: warning: Function parameter or
>                           member 'vma' not described in 'ima_file_mprotect'
> security/integrity/ima/ima_main.c:636: warning: Function parameter or
>                   member 'inode' not described in 'ima_post_create_tmpfile'
> security/integrity/ima/ima_main.c:636: warning: Excess function parameter
>                             'file' description in 'ima_post_create_tmpfile'
> security/integrity/ima/ima_main.c:843: warning: Function parameter or
>                      member 'load_id' not described in 'ima_post_load_data'
> security/integrity/ima/ima_main.c:843: warning: Excess function parameter
>                                    'id' description in 'ima_post_load_data'
> 
> Also, fix some style issues in the description of ima_post_create_tmpfile()
> and ima_post_path_mknod().
> 
> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

