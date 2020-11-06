Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7097D2A9E82
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgKFUQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:16:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42156 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728140AbgKFUQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:16:04 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6KDVNS016646;
        Fri, 6 Nov 2020 15:15:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=30z4bq0m/Oo0dHkbPgeBzPpXik7wZhTf1MuHJ1dCot4=;
 b=Llmek9zptfP8uDBaJdvdRpHvRI6enN8NWt34syvEgfBjVTQeRLBEZNOt1joLOORVCxmf
 k25t1WJR9PO7v5waCCGINLk78QtyuNJ3rpF+RbZUwKBRvhFzNJptEh1OmA90zigSvpWv
 X1D0XH6ywpFFZ7UM1G8iOAM1gPLSSBtU3OqFrwrslyuuddUvJGdxRVeOm/1ErSwEj4d1
 d1Rqmn+IlaXJJmCDLdy2AUI+gk9avZa41aBTS1Ck+ed7+sayu8FpXm+wYI9DvOHhLbEF
 qHkByepg0v/AHCD+/TUrVDrGpE0dTH1KEaqlrlOpzBbTuGTibWaV4/MP1wiR7wQdRhR4 vw== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34n6h8ds1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 15:15:55 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6KBpP4008660;
        Fri, 6 Nov 2020 20:15:54 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 34h0s890ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 20:15:54 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6KFkQ339780850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 20:15:46 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 620EF6E04E;
        Fri,  6 Nov 2020 20:15:52 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2336D6E052;
        Fri,  6 Nov 2020 20:15:52 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 20:15:51 +0000 (GMT)
MIME-Version: 1.0
Date:   Fri, 06 Nov 2020 14:15:51 -0600
From:   ljp <ljp@linux.vnet.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     wvoigt@us.ibm.com, netdev@vger.kernel.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+ljp=linux.ibm.com@lists.ozlabs.org>,
        Dany Madden <drt@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next] Revert ibmvnic merge do_change_param_reset into
 do_reset
In-Reply-To: <20201106114208.4b0e8eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201106191745.1679846-1-drt@linux.ibm.com>
 <0ff353cbada91b031d1bbae250a975d5@linux.vnet.ibm.com>
 <20201106114208.4b0e8eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <f0bb7f558a24cfc16bb05754a847fca1@linux.vnet.ibm.com>
X-Sender: ljp@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-06 13:42, Jakub Kicinski wrote:
> On Fri, 06 Nov 2020 13:30:25 -0600 ljp wrote:
>> On 2020-11-06 13:17, Dany Madden wrote:
>> > This reverts commit 16b5f5ce351f8709a6b518cc3cbf240c378305bf
>> > where it restructures do_reset. There are patches being tested that
>> > would require major rework if this is committed first.
>> >
>> > We will resend this after the other patches have been applied.
>> 
>> I discussed with my manager, and he has agreed not revert this one
>> since it is in the net-next tree and will not affect net tree for
>> current bug fix patches.
> 
> We merge net into net-next periodically (~every week or so) so if you
> keep making changes to both branches I will have to deal with the
> fallout.
> 
> I'm assuming that the resolution for the current conflict which Stephen
> Rothwell sent from linux-next is correct. Please confirm.

That fix is correct.

> 
> I will resolve it like he did when Linus pulls from net (hopefully
> later today).
> 
> But if you know you have more fixes I'd rather revert this, get all the
> relevant fixed into net, wait for net to be merged into net-next and
> then redo the refactoring.
> 
> Hope that makes sense.
