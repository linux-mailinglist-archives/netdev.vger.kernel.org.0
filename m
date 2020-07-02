Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E873921247B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgGBNW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:22:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30674 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729067AbgGBNW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 09:22:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 062DLZtt019972;
        Thu, 2 Jul 2020 06:22:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=6Kwa79/B4oYeiDXtVKCW5HHWsBXKxKO2pXdcKdrUd7I=;
 b=dpYuNn8qAZc1T3BMBlze1uXhh2kD+WhaN5vrHR+4qNAQTWWcT+q1HrIPd3RKSzKwj7GW
 eEhPlZjAMx3aeXX8x2Y4fDQpcBO+w1S7jDv/u9p6JE9gCRfWpoXhEqNIIZUT3u8hu+4S
 /kzFnHqSX9tK6QDzAwKsH65bmEZeWiNmGFdcN3SG4IePOG9aAwETzolR6dCBDobrZWR4
 xs1aRYNPso2Qyyi33Gu09Hziwuwm6LcwWOyEGK8fDdPACDEQ4mA8kHcKNzpiOcaq83aj
 sUY14Wp0jGAkp9DgQmUjJUHgU4AtRF7sX3yDT4j5yFBnT0ENa/f0zJvQEtoYkWcwJxKy fQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 31x5mnwd53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 06:22:51 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 06:22:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 06:22:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jul 2020 06:22:49 -0700
Received: from [10.193.54.28] (unknown [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id B6B243F703F;
        Thu,  2 Jul 2020 06:22:45 -0700 (PDT)
Subject: Re: [EXT] [PATCH v1 2/2] qlcninc: use generic power management
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Manish Chopra" <manishc@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        <skhan@linuxfoundation.org>
References: <20200702063632.289959-1-vaibhavgupta40@gmail.com>
 <20200702063632.289959-3-vaibhavgupta40@gmail.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <3aa3a243-6e9a-c80d-95d1-9c6a143e7eb4@marvell.com>
Date:   Thu, 2 Jul 2020 16:22:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200702063632.289959-3-vaibhavgupta40@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_08:2020-07-02,2020-07-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/07/2020 9:36 am, Vaibhav Gupta wrote:
> External Email
> 
> ----------------------------------------------------------------------
> With legacy PM, drivers themselves were responsible for managing the
> device's power states and takes care of register states. And they use PCI
> helper functions to do it.
> 
> After upgrading to the generic structure, PCI core will take care of
> required tasks and drivers should do only device-specific operations.
> 
> .suspend() calls __qlcnic_shutdown, which then calls qlcnic_82xx_shutdown;
> .resume()  calls __qlcnic_resume,   which then calls qlcnic_82xx_resume;
> 
> Both ...82xx..() are define in
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c and are used only in
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c.
> 
> Hence upgrade them and remove PCI function calls, like pci_save_state()
> and
> pci_enable_wake(), inside them
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Acked-by: Igor Russkikh <irusskikh@marvell.com>

Thanks!
