Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374D3B66A3
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 17:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbfIRPAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 11:00:14 -0400
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:31097 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731141AbfIRPAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 11:00:14 -0400
IronPort-SDR: bVAzho8b90J+5FSYZtqpX0IKD4cOMUk67Yof2HZMn0bh4kNay8p9JGJjDxshnG6RRR8T3efhIZ
 JmEWfiWpaDKlJ4RaGeBmTzGBilGTg/EE1DHR3YTNbsTdn1PywK9/xZ4OBUQR4/+cbFbTTcL4R5
 tBvnw9Y9e+HY7TfQLYiBYj0j5fFU7eWF30Tu7bqYzfcC0S6XXd0DsDNAoGqLsTiqSFVcJ5XnUe
 7Qk7xoEv8SpSs2UHmko8DWz8do3Kst6WDdqeJw2xyeDoB5box/JBwrMYnGzgOVvNxZ7PZOvXRP
 IMI=
X-IronPort-AV: E=Sophos;i="5.64,520,1559548800"; 
   d="scan'208";a="41469783"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 18 Sep 2019 07:00:13 -0800
IronPort-SDR: yaHjxxDXef728Zx9ob8/veTKYmyXI0/S3s3wjFXiESVvLv7KVTry0vRfDIX0TwXgHYDnv1Xew8
 LhMBw0e1IBp1l+O7UFY0yytVo/IMB685TseMk3FePgGDeunGG8N7TlF0/otHEbXFwMLy/qrAdM
 9MkMGA+Vsz5XXYL1IvklB7BONrtc8VurcFpMlC1TYj2c7+VJmYB/t92I8+xNtrntOrdLRfyc+/
 jSn3g+OSj14FVRAel1j1AbJKjQSSQbQTHxW6h52Wn9FARXgc57f8jKQpagkYEZybs/aI9aKQdu
 IKA=
Date:   Wed, 18 Sep 2019 11:00:09 -0400
From:   "George G. Davis" <george_davis@mentor.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: sysctl: cleanup net_sysctl_init error exit paths
Message-ID: <20190918150009.GD15686@mam-gdavis-lt>
References: <1558020189-16843-1-git-send-email-george_davis@mentor.com>
 <20190516.142744.1107545161556108780.davem@davemloft.net>
 <20190517144345.GA16926@mam-gdavis-lt>
 <20190708224732.GA8009@mam-gdavis-lt>
 <20190917155354.GA15686@mam-gdavis-lt>
 <14606764-a026-c171-ba71-bf242a930e7e@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14606764-a026-c171-ba71-bf242a930e7e@6wind.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: svr-orw-mbx-03.mgc.mentorg.com (147.34.90.203) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Nicolas,

On Wed, Sep 18, 2019 at 11:44:55AM +0200, Nicolas Dichtel wrote:
> Le 17/09/2019 à 17:53, George G. Davis a écrit :
> [snip]
> > Ping, "Linux 5.3" kernel has been released [1] and it appears that the
> > 5.4 merge window is open. The patch [2] remains unchanged since my initial
> > post. Please consider applying it.
> 
> net-next is closed:
> http://vger.kernel.org/~davem/net-next.html
> 
> You will have to resend the patch when net-next opens.

Thanks! I'll watch for the "net-next is OPEN" announcment and resubmit then.

-- 
Regards,
George
