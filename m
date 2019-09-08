Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD795ACB8A
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 10:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfIHIVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 04:21:55 -0400
Received: from st43p00im-ztfb10061701.me.com ([17.58.63.172]:41004 "EHLO
        st43p00im-ztfb10061701.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726438AbfIHIVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 04:21:55 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Sep 2019 04:21:55 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mac.com; s=1a1hai;
        t=1567930398; bh=hrUWQ2DlZ/QwaaoOYVCxkzXnFDl7SgkqhuKt66U2cE0=;
        h=To:From:Subject:Message-ID:Date:Content-Type;
        b=HUj2sgwPZbvhw3gCI5ht1n3PSB2sgLhhkAKfMMS9BtiPRnKckLtqjEwHTBn8PdhxW
         4Murz8XvQ0/fA9Dgajx/Rg7Pp0tP+54X3R0spjWJhCDsCAZLkEWF+Dax+484oPPbyo
         OGJZwsEkS9sLb8qCxuk62rgk/ILe2AVC6yW+TezK2kT6pZe18DhiPqXnqENn5hZzKV
         YhWw0O8+AvbsR9T5ArgmTVa6uruKKTkQ4XbzBdOiYt77ydjWaQ/4eszkrTv5Cg/L4c
         K6MAeDlcB/txsINdxGwpQ/ifjs+1wz4+u4i1SNEsG5Qwe5J3GJ8/xcru5KSQgz5csL
         MticyT4N2TQLA==
Received: from [11.11.11.1] (ec2-18-184-207-225.eu-central-1.compute.amazonaws.com [18.184.207.225])
        by st43p00im-ztfb10061701.me.com (Postfix) with ESMTPSA id A3C79AC0B1E
        for <netdev@vger.kernel.org>; Sun,  8 Sep 2019 08:13:18 +0000 (UTC)
To:     netdev@vger.kernel.org
From:   Daniel Schaffrath <daniel.schaffrath@mac.com>
Subject: Load-balancing considering queue lengths
Message-ID: <7205678a-4d29-a21b-2b57-78a9fac043af@mac.com>
Date:   Sun, 8 Sep 2019 10:13:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=500 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909080090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everybody,

when load balancing packets/bytes among several links it seems to be a 
natural choice to rely the decisions about the outgoing device on the 
current queue lengths of the available devices. Looking at typical 
netfilter configurations or nftlb this does not seem to be a common 
choice, though.

Considering the abilities of eBPF and netfilter I think it would be 
totally possible. But I might be mistaken in either regard (good idea / 
technical possibility).

I would be very grateful, if you could provide me with any pointers that 
I could educate myself on that matter.

Thanks a lot in advance, Daniel
