Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FB6691009
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 19:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjBISLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 13:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjBISLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 13:11:13 -0500
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0DB69507
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 10:10:56 -0800 (PST)
Received: (wp-smtpd smtp.wp.pl 24088 invoked from network); 9 Feb 2023 19:10:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1675966247; bh=DGz+s+UKipsTRikuhhVo2ejVzn08Ml4tRecmL3OhQV4=;
          h=From:To:Cc:Subject;
          b=GlldKrmeW2Z79k4a8LS+GgbgcO4MNMAxLXLHUvErnZDUEjEpdRO/zbziys6iOGB4b
           DojR2wBQcG80q82XhhCmx+l/XNVeRSbfKXa6ex8Ji9j0TuJ9ykavBF85Jcp9Arx48v
           kUhqvCpvPSNqq1Js7D9qqUJtb1E063DfHAoUsfXo=
Received: from 89-64-15-40.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.15.40])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <drv@mailo.com>; 9 Feb 2023 19:10:47 +0100
Date:   Thu, 9 Feb 2023 19:10:46 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Deepak R Varma <drv@mailo.com>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: Re: [PATCH] wifi: rt2x00: remove impossible test condition
Message-ID: <20230209181046.GA1446693@wp.pl>
References: <Y+S3bu19GWZeR9pm@ubun2204.myguest.virtualbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+S3bu19GWZeR9pm@ubun2204.myguest.virtualbox.org>
X-WP-MailID: d7335b10652026634d63a6a1420b71a7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [EWNV]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 02:35:50PM +0530, Deepak R Varma wrote:
> Variable vga_gain is a u8 and will never attain a value less than 0.
> Hence testing it for less 0 is impossible.
> Issue identified using unsigned_lesser_than_zero.cocci Coccinelle
> semantic patch. The issue was also reported by Kernel test Robot.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Deepak R Varma <drv@mailo.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
