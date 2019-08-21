Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D613998810
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbfHUXqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:46:00 -0400
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:17252 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728124AbfHUXqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 19:46:00 -0400
Received: from pps.filterd (m0170396.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LNjVZl027329;
        Wed, 21 Aug 2019 19:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dellteam.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=DU7oEIheIrhsvTByl+kSdcIol9+8ctzdpkcB7ValqPI=;
 b=DZRXRjuESZY8/2PQ3jalsCZO/cs3TuFQ20pdXvw2f18W/kASUpjw3Phou/yKq6qBM4HL
 1e9OT657mn8s2x98hQjsBTtQbmcyo27SCiHMKp79SogCRbeNrzXSoUD/xiK9HcLvNpim
 r9nHnwQQazsDJzYnmJpeIF/kdvHwmbToj59qg1i9M4RSdh4APQaNqgLIiC0IPnbzUWgV
 MXhgJah8x7HtGfSM62R4OXNnSFMV2flDyNA9/j1f+Mjv4ebL0jLbKTwK1ejR4jfKLsmN
 j/1F5DnoWibnQmM4nJwpFal+j36dY2cQxI6+3TsAY1bxo3sz/LS1zTZ0PF8bRkvsV4fB UQ== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0b-00154904.pphosted.com with ESMTP id 2ugh2s0hfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 19:45:58 -0400
Received: from pps.filterd (m0144102.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LNiDj6141354;
        Wed, 21 Aug 2019 19:45:58 -0400
Received: from ausxipps310.us.dell.com (AUSXIPPS310.us.dell.com [143.166.148.211])
        by mx0b-00154901.pphosted.com with ESMTP id 2uhdktsh99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 19:45:58 -0400
X-LoopCount0: from 10.166.132.131
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="411265551"
From:   <Charles.Hyde@dellteam.com>
To:     <andrew@lunn.ch>
CC:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <Mario.Limonciello@dell.com>,
        <oliver@neukum.org>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: Re: [RFC 1/4] Add usb_get_address and usb_set_address support
Thread-Topic: [RFC 1/4] Add usb_get_address and usb_set_address support
Thread-Index: AQHVV6TlN6JhPmp8+EufEIlfFi8+LKcFInYAgAEhuRk=
Date:   Wed, 21 Aug 2019 23:45:55 +0000
Message-ID: <1566431155587.57889@Dellteam.com>
References: <1566339522507.45056@Dellteam.com>,<20190821012258.GB4285@lunn.ch>
In-Reply-To: <20190821012258.GB4285@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.177.90.69]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=438 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210233
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=541 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908210234
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> The core USB driver message.c is missing get/set address functionality=
=0A=
>> that stops ifconfig from being able to push MAC addresses out to USB=0A=
>> based ethernet devices.  Without this functionality, some USB devices=0A=
>> stop responding to ethernet packets when using ifconfig to change MAC=0A=
>> addresses.=0A=
>=0A=
> Hi Charles=0A=
>=0A=
> ifconfig has been deprecated for years, maybe a decade. Please=0A=
> reference the current tools, iproute2.=0A=
>=0A=
>           Andrew=0A=
=0A=
=0A=
Thank you.  I would, but that is not available on the system under test, wh=
ile ifconfig is.=0A=
=0A=
Charles Hyde=
