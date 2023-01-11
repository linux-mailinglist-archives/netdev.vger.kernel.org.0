Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912776660D9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbjAKQmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbjAKQma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:42:30 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14171CD6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:41:40 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id w3so17366516ply.3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SwR1GeWIGaWn3ZoEoDmQhGygde8m0im9zXMU7H9+R0o=;
        b=V+dqjD/nSIMIBaZlaty8dZzxLqNuLE52cJBkkt+W8yGVpx9rawNHCFchiXlkNCzGOY
         GYAnx7o3WYgxeR0xPMkB0ws1PiaEmDp2nURD149CBz9XwYtenGLwHCDzHY09DIJcyDF4
         ELxDfH/SdBGbhhqWFI3i3i+LU/OM7eKK00dC8AUtYC3E+L28ZxbKAN/7HxD7ISFnbUL4
         Tq2rjAcTq/3QioGy+RLgCtL6Fh0uWJDrYuhCRK1PEd5BxrBp8iW6jFkF50Lpwg8zV8Jv
         I6klMXbuPfl97oMPHPE6ZvNucNlA66nvAK9FR/rp8YTlrg5OaCS/NFrhizuJsbeTIhsI
         9MGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SwR1GeWIGaWn3ZoEoDmQhGygde8m0im9zXMU7H9+R0o=;
        b=3ypAZ5P5qyRId6Rpmz27ATHFrTyL52FtAOkUbajlkU2HQRZjVZofSbKY6epiV4czsR
         Q9USeKtYe7HReRlq1n2RofJmY4AOXKx0G2FG6weTA4IE+RqCsiYSuywGQnikujfSW2pc
         tPRG55n9bepUvJkaLCXCXjg9hycZx+cxTuvRcBrogYwWUSOSOyS3xEcNeiDOBTHIkIN6
         o9lb1rUmKw80iGyTCaejndvAPgQw3N8r7lNfoOAvWlum9+NRAlhOhLs2U14lvV5jHwwT
         od27ZlmuZOmmqSXf1r87h6WIfltJcVhUmkGqHCaKK+XEuWR96VTp+/NH4RToeFw9E7gk
         DWcw==
X-Gm-Message-State: AFqh2ko4+ydsjb+Wi4U0Wsl4x96cvQN7qyvy3tTgscUrkfL4e6+uijLu
        HSD/MdHDYDKz1DyQZnCARao=
X-Google-Smtp-Source: AMrXdXsxncUALiWoqbZDdBIL3LusBI8mi/53aCOK3rjsfiumMDCg3Tt+A/PiuPVWIcZpEQyxfQvOrg==
X-Received: by 2002:a17:90a:5901:b0:219:b936:6bd7 with SMTP id k1-20020a17090a590100b00219b9366bd7mr74581851pji.19.1673455299558;
        Wed, 11 Jan 2023 08:41:39 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id qe9-20020a17090b4f8900b001df264610c4sm6028232pjb.0.2023.01.11.08.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 08:41:39 -0800 (PST)
Message-ID: <614aea713d8e48074eb4b9d5162e3abdfbf1c937.camel@gmail.com>
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2023-01-10 (ixgbe, igc, iavf)
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org
Date:   Wed, 11 Jan 2023 08:41:38 -0800
In-Reply-To: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
References: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-10 at 14:38 -0800, Tony Nguyen wrote:
> This series contains updates to ixgbe, igc, and iavf drivers.
>=20
> Yang Yingliang adds calls to pci_dev_put() for proper ref count tracking
> on ixgbe.
>=20
> Christopher adds setting of Toggle on Target Time bits for proper
> pulse per second (PPS) synchronization for igc.
>=20
> Daniil Tatianin fixes, likely, copy/paste issue that misreported
> destination instead of source for IP mask for iavf error.
>=20
> The following are changes since commit 53da7aec32982f5ee775b69dce06d63992=
ce4af3:
>   octeontx2-pf: Fix resource leakage in VF driver unbind
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE
>=20
> Christopher S Hall (1):
>   igc: Fix PPS delta between two synchronized end-points
>=20
> Daniil Tatianin (1):
>   iavf/iavf_main: actually log ->src mask when talking about it
>=20
> Yang Yingliang (1):
>   ixgbe: fix pci device refcount leak
>=20
>  drivers/net/ethernet/intel/iavf/iavf_main.c  |  2 +-
>  drivers/net/ethernet/intel/igc/igc_defines.h |  2 ++
>  drivers/net/ethernet/intel/igc/igc_ptp.c     | 10 ++++++----
>  drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 14 +++++++++-----
>  4 files changed, 18 insertions(+), 10 deletions(-)
>=20

Series looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
