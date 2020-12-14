Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E5F2D9F78
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 19:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731829AbgLNSpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 13:45:49 -0500
Received: from mail1.bemta23.messagelabs.com ([67.219.246.5]:9135 "EHLO
        mail1.bemta23.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440960AbgLNSpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 13:45:23 -0500
Received: from [100.112.3.43] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-b.us-east-1.aws.symcld.net id 22/43-54546-8A1B7DF5; Mon, 14 Dec 2020 18:40:40 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRWlGSWpSXmKPExsWS8eIhj+6Kjdf
  jDe4eZLH4MOcBo8X/medYLf7Pvc1isfvCDyaLQ+cOMFsceTaV1WLO+RYWi/+3frNanNh8n9Hi
  wrY+VovLu+awWTR1NrFZHFsgZtHy5BGzxe6fkxktZrUsY7W4OOEcq4Ogx6yGXjaPLStvMnlMm
  jmD2WPnrLvsHov3vGTy2LSqk83jZHOpx/t9V9k8Pm+SC+CMYs3MS8qvSGDN2Ni/kr1gj2DFpp
  lvWBsYP/N1MXJxCAn8Z5To/TiFHcJ5wShx+c4qpi5GTg5hgVCJY3+a2EASIgIzmSQuLvzOCFF
  1lFGiY+ZGVhCHWeA1s8T1aWuYQVrYBLQltmz5xQZi8wrYSlze8RAsziKgKnF450lWEFtUIFxi
  /ZKVjBA1ghInZz5hAbE5BWIl7p/ZBnQHB9BQTYn1u/RBwswC4hK3nsxngrDlJZq3zgYbKSGgI
  HG5exMbhJ0gsezlHeYJjIKzkEydhTBpFpJJs5BMWsDIsorRNKkoMz2jJDcxM0fX0MBA19DQSB
  dE6iVW6SbplRbrpiYWl+gCueXFesWVuck5KXp5qSWbGIFxnVLAwL2DceubD3qHGCU5mJREefn
  XXI8X4kvKT6nMSCzOiC8qzUktPsQow8GhJMG7ZQNQTrAoNT21Ii0zB5hiYNISHDxKIrxCwDQj
  xFtckJhbnJkOkTrFqMtx8uCSRcxCLHn5ealS4rxuIDMEQIoySvPgRsDS3SVGWSlhXkYGBgYhn
  oLUotzMElT5V4ziHIxKwryyIKt4MvNK4Da9AjqCCeiIF8cugxxRkoiQkmpgUrl/8rz8MqZPGd
  silz49nX//6uuFEitariQf2vQsfSLfndWbUu4oOHms5q/KNP0/c8/lLypyJ9R9n104ZZ7PPan
  6OTPr0hurSoU/68VU2D44ayF3mPVdXd6h9qvTm0JfP9ZydzlyYmJibWRqspj6/wvvnHMv68Uf
  23Bxc1MOw1wmY8UXFiuUQrmeGK3NNnoXl/n9z9rWCOWOuQ+/LVvMwbbPtc3xrsCfK3lBD5peL
  5yzPuTCLOOT15ffXXvS/GJLqM1+B4EVX22Ce+fdqNjtt9Fxi6HfO+4KR7e3NwO65/wTvezVvO
  drsfSSs5k53FG1mQtuy9Suz5Jw8+3OKJye5RwiW6gUe+fiPUUn/bvL+ZVYijMSDbWYi4oTAQ5
  sVcHyAwAA
X-Env-Sender: markpearson@lenovo.com
X-Msg-Ref: server-15.tower-386.messagelabs.com!1607971239!240127!1
X-Originating-IP: [104.232.225.12]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.60.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 2545 invoked from network); 14 Dec 2020 18:40:40 -0000
Received: from unknown (HELO lenovo.com) (104.232.225.12)
  by server-15.tower-386.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 14 Dec 2020 18:40:40 -0000
Received: from reswpmail04.lenovo.com (unknown [10.62.32.23])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by Forcepoint Email with ESMTPS id C85F91614D85C50BF915;
        Mon, 14 Dec 2020 13:40:39 -0500 (EST)
Received: from localhost.localdomain (10.38.98.145) by reswpmail04.lenovo.com
 (10.62.32.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2044.4; Mon, 14 Dec
 2020 10:40:38 -0800
Subject: Re: Fw: [External] Re: [PATCH v4 0/4] Improve s0ix flows for systems
 i219LM
To:     Mario Limonciello <mario.limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Aaron Ma <aaron.ma@canonical.com>
References: <20201214153450.874339-1-mario.limonciello@dell.com>
 <80862f70-18a4-4f96-1b96-e2fad7cc2b35@redhat.com>
 <PS2PR03MB37505A15D3C9B7505D679D7BBDC70@PS2PR03MB3750.apcprd03.prod.outlook.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Yijun.Shen@dell.com" <Yijun.Shen@dell.com>,
        "Perry.Yuan@dell.com" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>
From:   Mark Pearson <markpearson@lenovo.com>
Message-ID: <ae436f90-45b8-ba70-be57-d17641c4f79d@lenovo.com>
Date:   Mon, 14 Dec 2020 13:40:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <PS2PR03MB37505A15D3C9B7505D679D7BBDC70@PS2PR03MB3750.apcprd03.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.38.98.145]
X-ClientProxiedBy: reswpmail04.lenovo.com (10.62.32.23) To
 reswpmail04.lenovo.com (10.62.32.23)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Hans

On 14/12/2020 13:31, Mark Pearson wrote:
> 
> 
> ------------------------------------------------------------------------
> *From:* Hans de Goede <hdegoede@redhat.com>
> *Sent:* December 14, 2020 13:24
> *To:* Mario Limonciello <mario.limonciello@dell.com>; Jeff Kirsher
> <jeffrey.t.kirsher@intel.com>; Tony Nguyen <anthony.l.nguyen@intel.com>;
> intel-wired-lan@lists.osuosl.org <intel-wired-lan@lists.osuosl.org>;
> David Miller <davem@davemloft.net>; Aaron Ma <aaron.ma@canonical.com>;
> Mark Pearson <mpearson@lenovo.com>
> *Cc:* linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>;
> Netdev <netdev@vger.kernel.org>; Alexander Duyck
> <alexander.duyck@gmail.com>; Jakub Kicinski <kuba@kernel.org>; Sasha
> Netfin <sasha.neftin@intel.com>; Aaron Brown <aaron.f.brown@intel.com>;
> Stefan Assmann <sassmann@redhat.com>; darcari@redhat.com
> <darcari@redhat.com>; Yijun.Shen@dell.com <Yijun.Shen@dell.com>;
> Perry.Yuan@dell.com <Perry.Yuan@dell.com>; anthony.wong@canonical.com
> <anthony.wong@canonical.com>
> *Subject:* [External] Re: [PATCH v4 0/4] Improve s0ix flows for systems
> i219LM
>  
> Hi All,
> 
<snip>
> 
> ###
> 
> I've added Mark Pearson from Lenovo to the Cc so that Lenovo
> can investigate this issue further.
> 
> Mark, this thread is about an issue with enabling S0ix support for
> e1000e (i219lm) controllers. This was enabled in the kernel a
> while ago, but then got disabled again on vPro / AMT enabled
> systems because on some systems (Lenovo X1C7 and now also X1C8)
> this lead to suspend/resume issues.
> 
> When AMT is active then there is a handover handshake for the
> OS to get access to the ethernet controller from the ME. The
> Intel folks have checked and the Windows driver is using a timeout
> of 1 second for this handshake, yet on Lenovo systems this is
> taking 2 seconds. This likely has something to do with the
> ME firmware on these Lenovo models, can you get the firmware
> team at Lenovo to investigate this further ?
Absolutely - I'll ask them to look into this again.

We did try to make progress with this previously - but it got a bit
stuck and hence the need for these patches....but I believe things may
have changed a bit so it's worth trying again

Mark
