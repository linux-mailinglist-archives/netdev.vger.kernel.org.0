Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C8C2B8EB5
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgKSJZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:25:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgKSJZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 04:25:41 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ92Pf2129675;
        Thu, 19 Nov 2020 04:25:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fvt0SJkbiQ/Y33pq5+RUe+SaSp1D1DzABxGVOT03/Fg=;
 b=I3ff7yP8hYTEhYc7hzed6zFDawEHQNouS0V0xE9lmK+n2XqDFMZHZFyzdKljByQOv/86
 F6vYQDWbROKK1cMpXbxqRtcORbRc0DXiS/TGPCdgk/cuYqtDlwkPY6C7UDDIzkMBHbpc
 6J3mv+4JggwVFx9N9hxqPAjEkvQ1b8pVsdS9xeg0h8G/3dCPGhGLzhTnZcdSO/ifQIaV
 BwO2pYQjWxNTi+J31KPwFEy32M+TiQoKsGcmkCruHlswOfBJCg8jNPi93hI/NAbnec3h
 9s38Le26LxPTRxTONnV5SaniFzbtai6keoSdpRuaEvJIGpQQoCZGMUeuY3ZdtOKj+6nP zw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34wg5s12kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 04:25:37 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ9OQUL027286;
        Thu, 19 Nov 2020 09:25:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 34t6gham35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 09:25:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ9PWWh7864926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 09:25:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D5BE5204E;
        Thu, 19 Nov 2020 09:25:32 +0000 (GMT)
Received: from [9.145.53.92] (unknown [9.145.53.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2082C5204F;
        Thu, 19 Nov 2020 09:25:32 +0000 (GMT)
Subject: Re: [PATCH net-next 0/9] s390/qeth: updates 2020-11-17
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
 <20201118173517.4cfaa900@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <46384624-7fbe-fc18-9dd5-fb9c114a1868@linux.ibm.com>
Date:   Thu, 19 Nov 2020 11:25:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201118173517.4cfaa900@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_05:2020-11-17,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=910 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011190063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.11.20 03:35, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 17:15:11 +0100 Julian Wiedmann wrote:
>> please apply the following patch series for qeth to netdev's net-next tree.
>>
>> This brings some cleanups, and a bunch of improvements for our
>> .get_link_ksettings() code.
> 
> Applied, thanks!
> 

Thank you! Looks like you missed patch 1 in the series though... no biggie,
I'll resend it with the next batch of patches.
