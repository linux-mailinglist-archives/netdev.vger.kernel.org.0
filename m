Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC1F96C08
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbfHTWPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:15:35 -0400
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:28410 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbfHTWPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:15:34 -0400
Received: from pps.filterd (m0170394.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMF59Y004387;
        Tue, 20 Aug 2019 18:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dellteam.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=smtpout1; bh=k4N0uNoKfvboVHjPxqEV3uL80ZQHKYo+/ZDhxJ+cxRw=;
 b=MPZViomJzEQI51s2kvIU2dgYlG+8xFw80bOLJmMym3OVzqhVRbUcbHcT1h1cLYQwJ1x3
 LfLa4hJywbZrW5mpLFCf9iR3AW6uhiHELafot5zT7PSl76GUnMcYE9WygnmjTK500YUn
 wUFZG+KigHJgTKixnLmeKk16tedJH3LYK+tgeVty4HIHLMs4GJUBb4sZAMjcoaXLK57K
 EMcjT3r7+Js920nTmi+DtFWQqDdbW6lzYkA4nhXV4qismeVmFWfpbwK6vx1ZejUPbXeH
 8PFX2HRYbRaEIykBmNFsR7dDcBVfQuOUAHO0s5JlPYr3fm1twuoMCZ/PK2hNIw3D780A cg== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 2ugh3g2gs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 18:15:33 -0400
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMD0Dd090304;
        Tue, 20 Aug 2019 18:15:32 -0400
Received: from ausxippc106.us.dell.com (AUSXIPPC106.us.dell.com [143.166.85.156])
        by mx0a-00154901.pphosted.com with ESMTP id 2ugp98tr04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 18:15:32 -0400
X-LoopCount0: from 10.166.132.129
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="450247478"
From:   <Charles.Hyde@dellteam.com>
To:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <Mario.Limonciello@dell.com>,
        <oliver@neukum.org>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: [RFC 0/4] Add support into cdc_ncm for MAC address pass through
Thread-Topic: [RFC 0/4] Add support into cdc_ncm for MAC address pass through
Thread-Index: AQHVV6TGV+GduTX4ZESeohSN/8VROg==
Date:   Tue, 20 Aug 2019 22:15:29 +0000
Message-ID: <89a5f8ea30b240babd8750d236ca9ef4@AUSX13MPS303.AMER.DELL.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.177.90.69]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=472 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200204
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=570 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200204
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In recent testing of a Dell Universal Dock D6000, I found that MAC address =
pass through is not supported in the Linux drivers.  However, this same dev=
ice is supported in Windows 10 (Pro) on my personal computer, in as much as=
 I was able to tell Windows to assign a new MAC address of my choosing, and=
 I saw through wireshark the new MAC address was pushed out to the device. =
 Afterward, Windows reported a new IP address and I was able to view web pa=
ges.=0A=
=0A=
This series of patches give support to USB based Ethernet controllers for p=
rogramming a MAC address to the device, and also to retrieve the device's M=
AC address using the existing USB protocol for these two functions.  This p=
atch series further adds ACPI MAC address pass through support specifically=
 for the cdc_ncm driver, and generally for any other driver that may need o=
r want it, in furtherance of Dell's enterprise IT policy efforts.  It was t=
his latter that I initially found lacking when testing a D6000 with a Dell =
laptop, and then I found ifconfig was unable to set a MAC address into the =
device.  These patches bring a similar level of functionality to cdc_ncm dr=
iver as is available with the Realtek r8152 driver, and is available with W=
indows.=0A=
=0A=
Charles Hyde (4):=0A=
  Add usb_get_address and usb_set_address support=0A=
  Allow cdc_ncm to set MAC address in hardware=0A=
  Move ACPI functionality out of r8152 driver=0A=
  net: cdc_ncm: Add ACPI MAC address pass through functionality=0A=
=0A=
 drivers/net/usb/cdc_ncm.c  | 28 +++++++++++++++++-=0A=
 drivers/net/usb/r8152.c    | 44 +++-------------------------=0A=
 drivers/net/usb/usbnet.c   | 37 ++++++++++++++++++------=0A=
 drivers/usb/core/message.c | 59 ++++++++++++++++++++++++++++++++++++++=0A=
 include/linux/usb.h        |  3 ++=0A=
 include/linux/usb/usbnet.h |  1 +=0A=
 lib/Makefile               |  3 +-=0A=
 7 files changed, 124 insertions(+), 51 deletions(-)=0A=
=0A=
-- =0A=
2.20.1=0A=
