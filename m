Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397BC68F8B6
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbjBHUSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbjBHUSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:18:02 -0500
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6912E0E6
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 12:18:00 -0800 (PST)
Received: (wp-smtpd smtp.wp.pl 1855 invoked from network); 8 Feb 2023 21:17:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1675887478; bh=PtURNfYEoKITRRbyvk3vAQH6aL3o5R7Jm4zlISWUBUM=;
          h=From:To:Cc:Subject;
          b=fqUDeB8a1xUM0pXzczkN9tCMadnMUY2uSXYk2R+avJsCdl+QST3+CMFb2jlmqPHwf
           nncJnnX0CMB+M1CqBfTQ3g60i/so/U4eo1AmvMhoZZ0GvUKwgPNWui5hSeSM29kRn4
           CKstOkGQosv44Ngaf1b1cVo9SMNlbelF97Yw3HYI=
Received: from 89-64-15-40.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.15.40])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jiasheng@iscas.ac.cn>; 8 Feb 2023 21:17:58 +0100
Date:   Wed, 8 Feb 2023 21:17:57 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iwl3945: Add missing check for
 create_singlethread_workqueue
Message-ID: <20230208201757.GB1435569@wp.pl>
References: <20230208063032.42763-1-jiasheng@iscas.ac.cn>
 <20230208063032.42763-2-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208063032.42763-2-jiasheng@iscas.ac.cn>
X-WP-MailID: f397f3d1b287d936b978b5d9adf80467
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [obOV]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:30:32PM +0800, Jiasheng Jiang wrote:
> Add the check for the return value of the create_singlethread_workqueue
> in order to avoid NULL pointer dereference.
> 
> Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
