Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6011D60824A
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 01:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJUXyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 19:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJUXyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 19:54:37 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BBFDFEF
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 16:54:35 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f193so3941830pgc.0
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 16:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Me6fin4PKPxGzelvQr3GYpMUtNMCgChJyA1hFz3C6E=;
        b=hcZvOjFBxNj04HqrTZV6lyiFAEv8pNqOZ047DAPLoTQ4I8fIdU/uPFy85OZ3cpabJo
         FsOZ5nOH4wwz3T/GLswZ5q42oe7j48l6BjInJdQC+hEXRKa+q2YOLlvyGucCnU5ipxw3
         92878EyKkV0nSO9ZpFQGv3TGucygS/ybNJ5FKHtUnrkFbPvd1gPNi1WZ2q+PzCyGLnW7
         ct1m14n5xcHc7Z6YytjdjNcq7qURCURxsyqIRcYw1nZQCpBkVZexHx6uvWQtKlbluCA7
         r+Ric8DSij0dec5vBzuOFLUeXwm3ipg8Naf/fLo7OZ1CGgh7V0xNhzucGwcPNiMXIwwM
         eKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Me6fin4PKPxGzelvQr3GYpMUtNMCgChJyA1hFz3C6E=;
        b=MBnk5Q8HGG8yNAER2ibqAvcQq71YJ/NcSI6ft983Yqa6m+PTp8sX0/UGP9Oga16D3J
         ctNjkhmRtYxQu/FS7MsP1nwCvSKhKXO9MXAY8LHAx4X822BEmbdiR4BK7UjRBxm1H7td
         bR7/fjSrA8U1CReP6EVD5qysXtFrQCdPnBEMmWB5xVVz4Hlv1Pddiz35MKvLEzrwfAwl
         nm6o0HFgHz401aY/DGXfowWYnU2SyO9GBA/WYRriFtYxJ7PYCEvK1bFb9yJ261lkBWF4
         vHEN05+F712QMw7FxF2va2ue++ZNZyl0s2hTMjOxF9bzuihojZtkc84JNUCg8sWpLe2C
         Sj1Q==
X-Gm-Message-State: ACrzQf24x7mAIowPo/OtUBH1EaC/V3x4WYJa3fC4un9GlZRlIMJJyO7G
        O2hjpnnAotQHFTqsiTrcAcA=
X-Google-Smtp-Source: AMsMyM4w+Su/R1X9Sy4JYHJ1MLAYx4X7ple3ZC8y9DnYmLbVN6Jtpt2Z4jvJPAIC8IQQeWeM0lL4sg==
X-Received: by 2002:a65:6c08:0:b0:448:c216:fe9 with SMTP id y8-20020a656c08000000b00448c2160fe9mr17929870pgu.243.1666396475212;
        Fri, 21 Oct 2022 16:54:35 -0700 (PDT)
Received: from arch-desk ([2601:601:9100:2c:40bc:2209:ea1d:5052])
        by smtp.gmail.com with ESMTPSA id 203-20020a6214d4000000b005626fcc32b0sm16161731pfu.175.2022.10.21.16.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 16:54:34 -0700 (PDT)
Date:   Fri, 21 Oct 2022 16:54:33 -0700
From:   Shane Parslow <shaneparslow808@gmail.com>
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
 mapping
Message-ID: <Y1MxOYp1G1RLhrQc@arch-desk>
References: <20220926040524.4017-1-shaneparslow808@gmail.com>
 <SJ0PR11MB5008658CADCDADE43C6B0D5BD7559@SJ0PR11MB5008.namprd11.prod.outlook.com>
 <YzPkeEE0rbCurF4L@arch-x1c>
 <SJ0PR11MB50088ED0054BD0C497E16A3BD72D9@SJ0PR11MB5008.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB50088ED0054BD0C497E16A3BD72D9@SJ0PR11MB5008.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 02:04:37PM +0000, Kumar, M Chetan wrote:
> > -----Original Message-----
> > From: Shane Parslow <shaneparslow808@gmail.com>
> > Sent: Wednesday, September 28, 2022 11:37 AM
> > To: Kumar, M Chetan <m.chetan.kumar@intel.com>
> > Cc: netdev@vger.kernel.org
> > Subject: Re: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control
> > channel mapping
> > 
> > On Tue, Sep 27, 2022 at 01:43:22PM +0000, Kumar, M Chetan wrote:
> > > > -----Original Message-----
> > > > From: Shane Parslow <shaneparslow808@gmail.com>
> > > > Sent: Monday, September 26, 2022 9:35 AM
> > > > To: shaneparslow808@gmail.com
> > > > Cc: Kumar, M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> > > > <linuxwwan@intel.com>; Loic Poulain <loic.poulain@linaro.org>;
> > > > Sergey Ryazanov <ryazanov.s.a@gmail.com>; Johannes Berg
> > > > <johannes@sipsolutions.net>; David S. Miller <davem@davemloft.net>;
> > > > Eric Dumazet <edumazet@google.com>; Jakub Kicinski
> > > > <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > > > netdev@vger.kernel.org; linux- kernel@vger.kernel.org
> > > > Subject: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control
> > > > channel mapping
> > > >
> > > > This patch fixes the control channel mapping for the 7360, which was
> > > > previously the same as the 7560.
> > > >
> > > > As shown by the reverse engineering efforts of James Wah [1], the
> > > > layout of channels on the 7360 is actually somewhat different from that
> > of the 7560.
> > > >
> > > > A new ipc_chnl_cfg is added specifically for the 7360. The new
> > > > config updates channel 7 to be an AT port and removes the mbim
> > > > interface, as it does not exist on the 7360. The config is otherwise
> > > > left the same as the 7560. ipc_chnl_cfg_get is updated to switch between
> > the two configs.
> > > > In ipc_imem, a special case for the mbim port is removed as it no
> > > > longer exists in the 7360 ipc_chnl_cfg.
> > > >
> > > > As a result of this, the second userspace AT port now functions
> > > > whereas previously it was routed to the trace channel. Modem crashes
> > > > ("confused phase", "msg timeout", "PORT open refused") resulting
> > > > from garbage being sent to the modem are also fixed.
> > >
> > > Trace channel is mapped to 3rd entry.
> > >
> > > /* Trace */
> > > { IPC_MEM_CTRL_CHL_ID_3, IPC_MEM_PIPE_6, IPC_MEM_PIPE_7,
> > >   IPC_MEM_TDS_TRC, IPC_MEM_TDS_TRC,
> > IPC_MEM_MAX_DL_TRC_BUF_SIZE,
> > >   WWAN_PORT_UNKNOWN },
> > >
> > > I cross checked by running AT test on 7360. Both ports are functional as
> > expected.
> > > We should be able to send or receive AT commands with existing below
> > config.
> > >
> > > /* IAT0 */
> > > { IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
> > >   IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT,
> > IPC_MEM_MAX_DL_AT_BUF_SIZE,
> > >   WWAN_PORT_AT },  -----------> wwan0at0
> > >
> > > /* IAT1 */
> > > { IPC_MEM_CTRL_CHL_ID_4, IPC_MEM_PIPE_8, IPC_MEM_PIPE_9,
> > >   IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT,
> > IPC_MEM_MAX_DL_AT_BUF_SIZE,
> > >   WWAN_PORT_AT }, ------------> wwan0at1
> > >
> > > Does this second AT port (wwan0at1) goes bad at some point or is
> > > always not functional/modem crashes sooner we issue AT command ?
> > >
> > > Could you please help to check the modem fw details by running below
> > command.
> > > at+xgendata
> > 
> > Upon further investigation, it looks like the modem crashes only occur after
> > S3 sleep, and are likely a different issue that this patch does not fix. Sorry for
> > the confusion.
> > 
> > I say that the channels are mapped incorrectly because upon opening
> > wwan0at0, I recieve "+XLCSINIT: UtaLcsInitializeRspCb received result = 0",
> > and no response to AT commands. The behavior I would expect, and the
> > behavior I get after applying the patch, is normal responses to AT commands
> > in the same way as wwan0at1 pre-patch.
> > 
> > To be clear, my patch points wwan0at0 to channel 4, and wwan0at1 to
> > channel 7. I have perhaps been ambiguous with the terms I have been using.
> 
> I cross checked the channel mapping. It is proper.
> In the present implementation 2 AT port are enabled and are mapped to channel 2 & 4.
> 
> 	/* IAT0 */
> 	{ IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
> 	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
> 	  WWAN_PORT_AT },
> 
> 	/* IAT1 */
> 	{ IPC_MEM_CTRL_CHL_ID_4, IPC_MEM_PIPE_8, IPC_MEM_PIPE_9,
> 	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
> 	  WWAN_PORT_AT },
> 
> The channel 7 you are mapping to wwanat1 is an additional AT channel which we have not mapped to/enabled by default.
> 
> I flashed the same version of FW (1920) on my setup and I see both the AT ports are functional as expected. If mapping was not 
> proper channel would not have returned response to any AT commands and the reason why you are seeing "+XLCSINIT:" is, 
> in that version of modem FW the GNSS module is returning UNSOL command on initialization. This was fixed in later fw.
> 
> But one issue I noticed is, modem is crashing in S3 sleep. This issue is also not observed with latest modem fw.
> 
> > 
> > To recap:
> > -- The modem crashes are likely an unrelated issue.
> > -- wwan0at0 is currently unresponsive to commands, and outputs
> >    "+XLCSINIT...", but responds normally post-patch.
> > 
> > AT+XGENDATA returns the following:
> > +XGENDATA: "XG736ES21S5E20NAMAV2DEFA19223101408
> > M2_7360_XMM7360_REV_2.1_RPC_NAND 2019-May-29 11:40:45
> > *XG736ES21S5E20NAMAV2DEFA19223101408__M.2_7360_MR2_01.1920.00
> > *"
> > "*"
> > "FAB-CODE:7*SDRAMVendor=0x08 (Winbond), SDRAMRevision=0x0000"
> > 
> > I don't see any firmware updates online.

Looks like my vendor's firmware is a bit behind upstream. Thanks for bearing
with me.

On another note, what would your opinions be on exposing the RPC interface
to userspace? My understanding is that the 7360 does not have an MBIM
interface, so configuration via RPC is required to bring up the modem.

Is an MBIM interface added in a later firmware version? Are there problems
with this approach?

It seems to me that this would be the last step in making the 7360 usable.

I'm imagining something along the lines of adding a WWAN_PORT_RPC to
wwan_core.c and updating iosm_ipc_chnl_cfg.c

Such an interface should be able to work with the existing xmm7360-pci
tool.
