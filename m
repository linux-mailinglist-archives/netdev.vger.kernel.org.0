Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECAC25972
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfEUUta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:49:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfEUUta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:49:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKmrSI015459;
        Tue, 21 May 2019 20:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=phgqE6fdqs3ROYc+sPKMzsrsofgmUur4zWbpaCoGN6U=;
 b=Hp7I1RCWSh6e5DirEehZ3K29lkyiTEC3HaCHZSIEYBjjGsuo2zvkAqkr8ykF7Lrs1Bu0
 bdXrMEfQoxUWOJ+5TZzD4e/XqmomK3uugNM96vuTxSSAkPqwNrNu1PrEvb4rTU+e3vim
 hCpx/9zOMU28ADQIkPoKES9J+iROIzndPpt8totgiJ0HQzsidmqZcciv7N/r0dLPJUEA
 yEGZNv+fACQY5Fd8P5rcrMPk1jplEdm2hURWAdYP3VAfUor6V7lJV5OS3pirb4JrfC88
 t4BiNgJ5CE5hauNBsZYFvFV+/MAgDUgJQoYpSTpulybBR6ne+djGAGSV/cWlwxXsWKmJ gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sjapqfx6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:48:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKmHAb171225;
        Tue, 21 May 2019 20:48:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2sm0476npf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 20:48:52 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4LKmqLn172245;
        Tue, 21 May 2019 20:48:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sm0476npb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:48:52 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LKmoWX030095;
        Tue, 21 May 2019 20:48:50 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 20:48:50 +0000
Date:   Tue, 21 May 2019 16:48:48 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     dtrace-devel@oss.oracle.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel@iogearbox.net,
        acme@kernel.org, mhiramat@kernel.org, rostedt@goodmis.org,
        ast@kernel.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521204848.GJ2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=503 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested, I resent the patch set as replies to the cover letter post
to support threaded access to the patches.
