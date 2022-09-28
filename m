Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41AB5ED478
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 08:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiI1GG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 02:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiI1GGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 02:06:55 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4286B118B0E
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 23:06:53 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id l65so11621854pfl.8
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 23:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=X95+0RY6JyTfVU81sLa1iKviIo7zkWc4ACVC8zwdEpY=;
        b=hJnnQQ09npRITpoOoZbujDU03cl83OqMlUqNzlcUCEO3L+5J4jLuCFkNpPA9ZNNw5s
         AYcnPDDUWh9k6/pDuJpZMHEL4Df7Ih7i6qPo+GE9a5/0BHcUT+Vjmx6nLex2ay4EODyb
         uzFUQKBlhN4ybNZlYGTjQOo+3veyBfN1rmyWN74AoXwFm4gQret2IPSTppbEc0JmJHM1
         u9EWO3+/xS/D/PWvaOEBkwUt0Q0l1HiUQCZc8aoGtsup8n1HpVdxPoE/PdzRJaIYREh4
         n6AEtu+vY1JLI/vKt1H29rHfyeXSLLCt0jBdBElVfRkJx0fpMiyNr8DyqvY3OiiO/wfg
         YTkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=X95+0RY6JyTfVU81sLa1iKviIo7zkWc4ACVC8zwdEpY=;
        b=x+Dk8w1GI4a5JwBeykCv1wyJWK1T8mf4J6CcPn+/cu7p2NBAyG8O/gvImdgWes8RHN
         4M4oOV/k6bnrTunvjX35BnQ+eEVmxMk+XZoAItoUrMzuex0p4T87hxChcSVRSiWsdLR0
         4taHCyA23p5YO3UKfydlTRw0g/WmT74scT8rHpomxOi/lo+f1ZpkPjmMscdgtALp7xg0
         NaGhVLsxINsV5NQYnMMgcjC4AD9bYeAFNh0+aMJ9o8nkSj83CjAK6bMwnB67gtbEBfte
         6fVERTASIvVCsbQqR9myt+IlFzvqgCTpgFiSXQj722g8mY+B+J0v0Yg3F5hNMjo6RSCm
         E5TA==
X-Gm-Message-State: ACrzQf3btZbL6FIvQk1Gy6uXPNzrMcfbHPFkN8yZfsxk8xmjU6d3ddFv
        xyyxs+gBVu6xkAKmsjA4eOI=
X-Google-Smtp-Source: AMsMyM67h3JjrsG7OnnWVuy+5lb0/dejD0ZKaFe/L+QMJfEgffLHQICPOHh6kxYoRbPorGPS+Q8b/Q==
X-Received: by 2002:a62:e702:0:b0:541:854b:3aaf with SMTP id s2-20020a62e702000000b00541854b3aafmr33408450pfh.41.1664345212720;
        Tue, 27 Sep 2022 23:06:52 -0700 (PDT)
Received: from arch-x1c ([2601:601:9100:2c:a5f7:5443:84bf:40f7])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902684e00b0016c57657977sm2690701pln.41.2022.09.27.23.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 23:06:51 -0700 (PDT)
Date:   Tue, 27 Sep 2022 23:06:48 -0700
From:   Shane Parslow <shaneparslow808@gmail.com>
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
 mapping
Message-ID: <YzPkeEE0rbCurF4L@arch-x1c>
References: <20220926040524.4017-1-shaneparslow808@gmail.com>
 <SJ0PR11MB5008658CADCDADE43C6B0D5BD7559@SJ0PR11MB5008.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB5008658CADCDADE43C6B0D5BD7559@SJ0PR11MB5008.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 01:43:22PM +0000, Kumar, M Chetan wrote:
> > -----Original Message-----
> > From: Shane Parslow <shaneparslow808@gmail.com>
> > Sent: Monday, September 26, 2022 9:35 AM
> > To: shaneparslow808@gmail.com
> > Cc: Kumar, M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> > <linuxwwan@intel.com>; Loic Poulain <loic.poulain@linaro.org>; Sergey
> > Ryazanov <ryazanov.s.a@gmail.com>; Johannes Berg
> > <johannes@sipsolutions.net>; David S. Miller <davem@davemloft.net>; Eric
> > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> > Paolo Abeni <pabeni@redhat.com>; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
> > mapping
> > 
> > This patch fixes the control channel mapping for the 7360, which was
> > previously the same as the 7560.
> > 
> > As shown by the reverse engineering efforts of James Wah [1], the layout of
> > channels on the 7360 is actually somewhat different from that of the 7560.
> > 
> > A new ipc_chnl_cfg is added specifically for the 7360. The new config
> > updates channel 7 to be an AT port and removes the mbim interface, as it
> > does not exist on the 7360. The config is otherwise left the same as the
> > 7560. ipc_chnl_cfg_get is updated to switch between the two configs.
> > In ipc_imem, a special case for the mbim port is removed as it no longer
> > exists in the 7360 ipc_chnl_cfg.
> > 
> > As a result of this, the second userspace AT port now functions whereas
> > previously it was routed to the trace channel. Modem crashes ("confused
> > phase", "msg timeout", "PORT open refused") resulting from garbage being
> > sent to the modem are also fixed.
> 
> Trace channel is mapped to 3rd entry.
> 
> /* Trace */
> { IPC_MEM_CTRL_CHL_ID_3, IPC_MEM_PIPE_6, IPC_MEM_PIPE_7,
>   IPC_MEM_TDS_TRC, IPC_MEM_TDS_TRC, IPC_MEM_MAX_DL_TRC_BUF_SIZE,
>   WWAN_PORT_UNKNOWN },
> 
> I cross checked by running AT test on 7360. Both ports are functional as expected.
> We should be able to send or receive AT commands with existing below config. 
> 
> /* IAT0 */
> { IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
>   IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
>   WWAN_PORT_AT },  -----------> wwan0at0
> 
> /* IAT1 */
> { IPC_MEM_CTRL_CHL_ID_4, IPC_MEM_PIPE_8, IPC_MEM_PIPE_9,
>   IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
>   WWAN_PORT_AT }, ------------> wwan0at1
> 
> Does this second AT port (wwan0at1) goes bad at some point or is always not functional/modem
> crashes sooner we issue AT command ?
> 
> Could you please help to check the modem fw details by running below command.
> at+xgendata

Upon further investigation, it looks like the modem crashes only occur
after S3 sleep, and are likely a different issue that this patch does
not fix. Sorry for the confusion.

I say that the channels are mapped incorrectly because upon opening
wwan0at0, I recieve "+XLCSINIT: UtaLcsInitializeRspCb received result = 0",
and no response to AT commands. The behavior I would expect, and the
behavior I get after applying the patch, is normal responses to AT
commands in the same way as wwan0at1 pre-patch.

To be clear, my patch points wwan0at0 to channel 4, and wwan0at1 to channel
7. I have perhaps been ambiguous with the terms I have been using.

To recap:
-- The modem crashes are likely an unrelated issue.
-- wwan0at0 is currently unresponsive to commands, and outputs
   "+XLCSINIT...", but responds normally post-patch.

AT+XGENDATA returns the following:
+XGENDATA: "XG736ES21S5E20NAMAV2DEFA19223101408
M2_7360_XMM7360_REV_2.1_RPC_NAND 2019-May-29 11:40:45
*XG736ES21S5E20NAMAV2DEFA19223101408__M.2_7360_MR2_01.1920.00*"
"*"
"FAB-CODE:7*SDRAMVendor=0x08 (Winbond), SDRAMRevision=0x0000"

I don't see any firmware updates online.
