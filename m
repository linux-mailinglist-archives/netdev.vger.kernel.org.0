Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765CF96C1C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbfHTWXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:23:20 -0400
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:40560 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbfHTWXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:23:19 -0400
Received: from pps.filterd (m0170390.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMLLSG031038;
        Tue, 20 Aug 2019 18:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dellteam.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=smtpout1; bh=Y6k0CXvcStQUDgctYziXK5EGTdaIgQ5HuRwJxvV3x7g=;
 b=PoR/yfkxhBL5vT6OC+yodv/kx2LmTvL/QwGiy9ZM4HkASSmq8G/vhDfR3YoPl5PJfMQr
 AB/osjC75PZsrvO17jmPONYBrs+u+q3swf8a3WqH4ha0CEmGEznQ76qL/i9THOlWmqjE
 tpEdSUY15PhjuJsfpzGbKqXCEKyqCdffTPmXBDKZmlWVljnUERk3lAM8BUjH0wAUn3Ed
 YoVY+plq3S/NY2koFHzGvOacR7ng3MyOhX/H7pXW/+TlcunJVpCvQQ6GiqTMTwvuLlA2
 1gcfyU0neO1CbQ68u2fF90p5gEjZ1Ml3IAG7VwzeU9tgNkTLBGuZz9W36n3xC+x4ct6s sA== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 2ugfdm2vx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 18:23:18 -0400
Received: from pps.filterd (m0090351.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KMNIEI137858;
        Tue, 20 Aug 2019 18:23:18 -0400
Received: from ausc60ps301.us.dell.com (ausc60ps301.us.dell.com [143.166.148.206])
        by mx0b-00154901.pphosted.com with ESMTP id 2ugr58s5jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 18:23:18 -0400
X-LoopCount0: from 10.166.132.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="1346990510"
From:   <Charles.Hyde@dellteam.com>
To:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <Mario.Limonciello@dell.com>,
        <oliver@neukum.org>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: [RFC 4/4] net: cdc_ncm: Add ACPI MAC address pass through
 functionality
Thread-Topic: [RFC 4/4] net: cdc_ncm: Add ACPI MAC address pass through
 functionality
Thread-Index: AQHVV6XcyyL7dINtZEiggXCPIGXHZw==
Date:   Tue, 20 Aug 2019 22:23:15 +0000
Message-ID: <ec7435e0529243a99f6949ee9efbede5@AUSX13MPS303.AMER.DELL.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.177.90.69]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=856 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200206
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=983 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200205
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support to cdc_ncm for ACPI MAC address pass through=0A=
functionality that also exists in the Realtek r8152 driver.  This is in=0A=
support of Dell's Universal Dock D6000, to give it the same feature=0A=
capability as is currently available in Windows and advertized on Dell's=0A=
product web site.=0A=
=0A=
Signed-off-by: Charles Hyde <charles.hyde@dellteam.com>=0A=
Cc: Mario Limonciello <mario.limonciello@dell.com>=0A=
Cc: Oliver Neukum <oliver@neukum.org>=0A=
Cc: linux-usb@vger.kernel.org=0A=
---=0A=
 drivers/net/usb/cdc_ncm.c | 8 ++++++++=0A=
 1 file changed, 8 insertions(+)=0A=
=0A=
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c=0A=
index f77c8672f972..1f046acca6fc 100644=0A=
--- a/drivers/net/usb/cdc_ncm.c=0A=
+++ b/drivers/net/usb/cdc_ncm.c=0A=
@@ -52,6 +52,7 @@=0A=
 #include <linux/usb/usbnet.h>=0A=
 #include <linux/usb/cdc.h>=0A=
 #include <linux/usb/cdc_ncm.h>=0A=
+#include <acpi/acpi_mac_passthru.h>=0A=
 =0A=
 #if IS_ENABLED(CONFIG_USB_NET_CDC_MBIM)=0A=
 static bool prefer_mbim =3D true;=0A=
@@ -930,11 +931,18 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct us=
b_interface *intf, u8 data_=0A=
 	usb_set_intfdata(ctx->control, dev);=0A=
 =0A=
 	if (ctx->ether_desc) {=0A=
+		struct sockaddr sa;=0A=
+=0A=
 		temp =3D usbnet_get_ethernet_addr(dev, ctx->ether_desc->iMACAddress);=0A=
 		if (temp) {=0A=
 			dev_dbg(&intf->dev, "failed to get mac address\n");=0A=
 			goto error2;=0A=
 		}=0A=
+		if (get_acpi_mac_passthru(&intf->dev, &sa) =3D=3D 0) {=0A=
+			memcpy(dev->net->dev_addr, sa.sa_data, ETH_ALEN);=0A=
+			if (usbnet_set_ethernet_addr(dev) < 0)=0A=
+				usbnet_get_ethernet_addr(dev, ctx->ether_desc->iMACAddress);=0A=
+		}=0A=
 		dev_info(&intf->dev, "MAC-Address: %pM\n", dev->net->dev_addr);=0A=
 	}=0A=
 =0A=
-- =0A=
2.20.1=0A=
