Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0827B987F2
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfHUXfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:35:12 -0400
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:57510 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbfHUXfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 19:35:11 -0400
Received: from pps.filterd (m0170398.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LNZ4aP025860;
        Wed, 21 Aug 2019 19:35:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dellteam.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=q4aCXQK8l7fOP39/+RDgOcLee9mLAu3DsxxDmf9VKE0=;
 b=t5aQ4g8wAunVH5pWWy2Nv/K1+dP82rMeRNowXAt4iQDrzVnWEj9cmRJB8Em4QoVKEog6
 KUQQgQyEACgPMUNtA7ie9soGruCZJwjuQwroa+cPQ1RKg0v2OXYcm9yCvm8x0ygWaKQy
 vxk2/R8iKUaF9QjbUmHkdxJfQUBK731uegeJMr5Uuq6c0EI+tetO9GL0buQtGQfpcDG8
 axba1sZFp5RKhVZnmkFNoL0FlyxNeArV+adkIJ2VLlOVo82jqJvfH6o+1sRZ7JzMZGw9
 QrNkoSfXjO6C1mSw1B3sJYN6nw5B79hmApJNTv6BspWsDIls1gseLQbGM6wxxZUJAeIF 1A== 
Received: from mx0b-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 2ugn6kq2se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 19:35:09 -0400
Received: from pps.filterd (m0090350.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LNYhLx078661;
        Wed, 21 Aug 2019 19:35:08 -0400
Received: from ausxipps306.us.dell.com (AUSXIPPS306.us.dell.com [143.166.148.156])
        by mx0b-00154901.pphosted.com with ESMTP id 2uh9vbmx1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 19:35:08 -0400
X-LoopCount0: from 10.166.132.134
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="363526694"
From:   <Charles.Hyde@dellteam.com>
To:     <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <Mario.Limonciello@dell.com>, <oliver@neukum.org>,
        <netdev@vger.kernel.org>, <nic_swsd@realtek.com>
Subject: Re: [RFC 1/4] Add usb_get_address and usb_set_address support
Thread-Topic: [RFC 1/4] Add usb_get_address and usb_set_address support
Thread-Index: AQHVV6TlN6JhPmp8+EufEIlfFi8+LKcE8QcAgAFHO1A=
Date:   Wed, 21 Aug 2019 23:35:06 +0000
Message-ID: <1566430506442.20925@Dellteam.com>
References: <1566339522507.45056@Dellteam.com>,<20190820222602.GC8120@kroah.com>
In-Reply-To: <20190820222602.GC8120@kroah.com>
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
 mlxlogscore=747 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210231
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=847 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908210232
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<snipped>=0A=
>=0A=
> This is a VERY cdc-net-specific function.  It is not a "generic" USB=0A=
> function at all.  Why does it belong in the USB core?  Shouldn't it live=
=0A=
> in the code that handles the other cdc-net-specific logic?=0A=
>=0A=
> thanks,=0A=
>=0A=
> greg k-h=0A=
=0A=
=0A=
Thank you for this feedback, Greg.  I was not sure about adding this to mes=
sage.c, because of the USB_CDC_GET_NET_ADDRESS.  I had found references to =
SET_ADDRESS in the USB protocol at https://wiki.osdev.org/Universal_Serial_=
Bus#USB_Protocol.  If one wanted a generic USB function for SET_ADDRESS, to=
 be used for both sending a MAC address and receiving one, how would you su=
ggest this be implemented?  This is a legit question because I am curious.=
=0A=
=0A=
Your feedback led to moving the functionality into cdc_ncm.c for today's te=
sting, and removing all changes from messages.c, usb.h, usbnet.c, and usbne=
t.h.  This may be where I end up long term, but I would like to learn if th=
ere is a possible solution that could live in message.c and be callable fro=
m other USB-to-Ethernet aware drivers.=0A=
=0A=
Thank you again,=0A=
Charles Hyde=0A=
=0A=
