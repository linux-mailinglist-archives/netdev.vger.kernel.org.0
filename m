Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B275B1727E3
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 19:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgB0SpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 13:45:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48863 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbgB0SpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 13:45:14 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1j7O9m-0003W9-7k; Thu, 27 Feb 2020 13:45:11 -0500
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id 01RIePji012877;
        Thu, 27 Feb 2020 13:40:25 -0500
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id 01RIePWF012876;
        Thu, 27 Feb 2020 13:40:25 -0500
Date:   Thu, 27 Feb 2020 13:40:25 -0500
From:   "John W. Linville" <linville@tuxdriver.com>
To:     "Singh, Varunpratap" <Varunpratap.Singh@smartwirelesscompute.com>
Cc:     "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Nagaraj, Vinay" <Vinay.Nagaraj@smartwirelesscompute.com>
Subject: Re: Query: CNSS WLAN.
Message-ID: <20200227184025.GB3353@tuxdriver.com>
References: <SN6PR04MB4142AB972E7046A24F1F911394EB0@SN6PR04MB4142.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR04MB4142AB972E7046A24F1F911394EB0@SN6PR04MB4142.namprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Varun,

Unfortunately, your questions is well outside of my areas of skill and
expertise. Hopefully Grant or someone else in your distribution list
will be more helpful.

Best regards!

John

On Thu, Feb 27, 2020 at 03:25:16PM +0000, Singh, Varunpratap wrote:
> Hi John,
> 
> I am trying to bring up two wifi-modules simultaneously, on Qualcomm Snapdragon SD820 processor and the Kernel version is 3.18.
> I connected the modules on PCIe_0 & PCIe_1.
> 
> As per my understanding the following device tree structure is responsible for driver probing.
> qcom,cnss {
>         compatible = "qcom,cnss";
>         wlan-bootstrap-gpio = <&tlmm 46 0>;
>         vdd-wlan-en-supply = <&wlan_en_vreg>;
>         vdd-wlan-supply = <&rome_vreg>;
>         vdd-wlan-io-supply = <&pm8994_s4>;
>         vdd-wlan-xtal-supply = <&pm8994_l30>;
>         vdd-wlan-core-supply = <&pm8994_s3>;
>         wlan-ant-switch-supply = <&pm8994_l18_pin_ctrl>;
>         qcom,wlan-en-vreg-support;
>         qcom,enable-bootstrap-gpio;
>         qcom,notify-modem-status;
>         pinctrl-names = "bootstrap_active", "bootstrap_sleep";
>         pinctrl-0 = <&cnss_bootstrap_active>;
>         pinctrl-1 = <&cnss_bootstrap_sleep>;
>         qcom,wlan-rc-num = <0>;
>         qcom,wlan-ramdump-dynamic = <0x200000>;
> 
>         qcom,msm-bus,name = "msm-cnss";
>         qcom,msm-bus,num-cases = <4>;
>         qcom,msm-bus,num-paths = <1>;
>         qcom,msm-bus,vectors-KBps =
>         /* No vote */
>                 <45 512 0 0>,
>                 /* Up to 200 Mbps */
>                 <45 512 41421 1520000>,
>                 /* Up to 400 Mbps */
>                 <45 512 96650 1520000>,
>                 /* Up to 800 Mbps */
>                 <45 512 207108 14432000>;
> };
> 
> Currently if I change the "qcom,wlan-rc-num = <0>;" to "qcom,wlan-rc-num = <1>;" the module connected on PCIe_1 will start working and vice-versa. But as per the requirement we need two probe getting succeeded i.e both the modules should be registered. Please, suggest how can I create two different nodes under cnss structure.
> 
> Any suggestion will be valuable.
> 
> 
> 
> With Regards,
> Varun Pratap Singh
> Software Engineer.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
