Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDE3AFFAC
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 17:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfIKPLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 11:11:05 -0400
Received: from mx0b-00191d01.pphosted.com ([67.231.157.136]:8748 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727873AbfIKPLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 11:11:05 -0400
X-Greylist: delayed 10485 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2019 11:11:04 EDT
Received: from pps.filterd (m0049462.ppops.net [127.0.0.1])
        by m0049462.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x8BCFT9v023051;
        Wed, 11 Sep 2019 08:16:07 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049462.ppops.net-00191d01. with ESMTP id 2uxxd033s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 08:16:07 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x8BCG6NE046046;
        Wed, 11 Sep 2019 07:16:06 -0500
Received: from zlp30499.vci.att.com (zlp30499.vci.att.com [135.46.181.149])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x8BCG2DK045960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 11 Sep 2019 07:16:02 -0500
Received: from zlp30499.vci.att.com (zlp30499.vci.att.com [127.0.0.1])
        by zlp30499.vci.att.com (Service) with ESMTP id 4DD9D4009E75;
        Wed, 11 Sep 2019 12:16:02 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30499.vci.att.com (Service) with ESMTP id 3977F4000323;
        Wed, 11 Sep 2019 12:16:02 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x8BCG2EX090923;
        Wed, 11 Sep 2019 07:16:02 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x8BCFutI090748;
        Wed, 11 Sep 2019 07:15:56 -0500
Received: from [10.156.47.86] (unknown [10.156.47.86])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id AE2B73601B8;
        Wed, 11 Sep 2019 05:15:55 -0700 (PDT)
Reply-To: mmanning@vyatta.att-mail.com
Subject: Re: VRF Issue Since kernel 5
To:     Gowen <gowen@potatocomputing.co.uk>,
        David Ahern <dsahern@gmail.com>,
        Alexis Bauvin <abauvin@online.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
 <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
From:   Mike Manning <mmanning@vyatta.att-mail.com>
Message-ID: <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
Date:   Wed, 11 Sep 2019 13:15:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-11_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=876 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909110113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gareth,
Could you please also check that all the following are set to 1, I
appreciate you've confirmed that the one for tcp is set to 1, and by
default the one for raw is also set to 1:

sudo sysctl -a | grep l3mdev

If not,
sudo sysctl net.ipv4.raw_l3mdev_accept=1
sudo sysctl net.ipv4.udp_l3mdev_accept=1
sudo sysctl net.ipv4.tcp_l3mdev_accept=1


Thanks
Mike



