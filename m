Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727331C7574
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgEFPzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbgEFPzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:55:53 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2B2C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 08:55:53 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id p13so949670qvt.12
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 08:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=M3Pl222wqifdcDoK6PLhBKqxaMI2qOgcnUmVMcPdDbk=;
        b=B4H6sdn0TE06NXC1g8r5sMQEMu8oerm0CYJcla7l2oFGp5bAEUCRvddo3zVzR2NccG
         n9fPvXzsJe8JV45RlKCntWoMF4CcUxNA4LjWiXggab0Db2u7cacpilckI1rrwgSfseYJ
         lfs9hUooPHwbiej0OI2rdWDCpPgB1vtn/3SmydxiaRBEaVLuCOjaBX6d0gzpLgWSYZla
         OY0W4hQ7cs8T64UObyZ41WyyCSE+K8dZsH17DpSLdzX/ignO1EgHs6VbosnyQ38/inCd
         vCy4NeXCBLKl+lgX8fIIusLg60o1fU4SpuYZvR89eXTwQKuYDXpT4zEEdHlXv/9dIGw0
         LuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=M3Pl222wqifdcDoK6PLhBKqxaMI2qOgcnUmVMcPdDbk=;
        b=spo0qUAnz61aymNWkR4bNmP49mjlqnJTrqDIzh/ELjrckusTgeAhl5rfFzpD8R3sOZ
         kGuZNuehl6NekfbVd0fcMqNdoO0//0xgeU2y6LlkCsVoxXmGUlwP2/rvH3Pkn692BgPb
         JK4zm7Ym5tPloaK/EfyhKR91KajIF9mdXYjOm+vJAStVlkMkwakKm+Ba6wQHPpHY9eV6
         JLyVQ2MH4cewBw74f8DnlvA+/mLsVVoYEe9TLbtXDpxbz24ovd29fpS+zlIzDMeT/Z1b
         pk8CkHcQ84C0X2VwF4YW/KAx+189rexUdPM+SBxpBIEmGawm9efTUs4dkXZ5v01SDB4o
         tm4A==
X-Gm-Message-State: AGi0Pub1uJbV1N71szBn8t9gs2R9l2x09krz0a+DHLbnBFRaEwc4jAvc
        OBKBXx47lsc8n4Nu4wjvycA=
X-Google-Smtp-Source: APiQypLngiMp8FlC0sihQf8aip8ZepzgXzdOwOEPMLdh7SIIBqUxL4fRN0SIRrFo0w8gHMb0ilZusw==
X-Received: by 2002:a0c:aa85:: with SMTP id f5mr8705709qvb.51.1588780552475;
        Wed, 06 May 2020 08:55:52 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c33sm1890982qtb.76.2020.05.06.08.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 08:55:51 -0700 (PDT)
Date:   Wed, 6 May 2020 11:55:50 -0400
Message-ID: <20200506115550.GB1265908@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com
Subject: Re: [PATCH v3 net-next 1/6] net: dsa: introduce a
 dsa_port_from_netdev public helper
In-Reply-To: <20200505192057.9086-2-olteanv@gmail.com>
References: <20200505192057.9086-1-olteanv@gmail.com>
 <20200505192057.9086-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 May 2020 22:20:52 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As its implementation shows, this is synonimous with calling
> dsa_slave_dev_check followed by dsa_slave_to_port, so it is quite simple
> already and provides functionality which is already there.
> 
> However there is now a need for these functions outside dsa_priv.h, for
> example in drivers that perform mirroring and redirection through
> tc-flower offloads (they are given raw access to the flow_cls_offload
> structure), where they need to call this function on act->dev.
> 
> But simply exporting dsa_slave_to_port would make it non-inline and
> would result in an extra function call in the hotpath, as can be seen
> for example in sja1105:
> 
> Before:
> 
> 000006dc <sja1105_xmit>:
> {
>  6dc:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
>  6e0:	e1a04000 	mov	r4, r0
>  6e4:	e591958c 	ldr	r9, [r1, #1420]	; 0x58c <- Inline dsa_slave_to_port
>  6e8:	e1a05001 	mov	r5, r1
>  6ec:	e24dd004 	sub	sp, sp, #4
> 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
>  6f0:	e1c901d8 	ldrd	r0, [r9, #24]
>  6f4:	ebfffffe 	bl	0 <dsa_8021q_tx_vid>
> 			6f4: R_ARM_CALL	dsa_8021q_tx_vid
> 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
>  6f8:	e1d416b0 	ldrh	r1, [r4, #96]	; 0x60
> 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
>  6fc:	e1a08000 	mov	r8, r0
> 
> After:
> 
> 000006e4 <sja1105_xmit>:
> {
>  6e4:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
>  6e8:	e1a04000 	mov	r4, r0
>  6ec:	e24dd004 	sub	sp, sp, #4
> 	struct dsa_port *dp = dsa_slave_to_port(netdev);
>  6f0:	e1a00001 	mov	r0, r1
> {
>  6f4:	e1a05001 	mov	r5, r1
> 	struct dsa_port *dp = dsa_slave_to_port(netdev);
>  6f8:	ebfffffe 	bl	0 <dsa_slave_to_port>
> 			6f8: R_ARM_CALL	dsa_slave_to_port
>  6fc:	e1a09000 	mov	r9, r0
> 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
>  700:	e1c001d8 	ldrd	r0, [r0, #24]
>  704:	ebfffffe 	bl	0 <dsa_8021q_tx_vid>
> 			704: R_ARM_CALL	dsa_8021q_tx_vid
> 
> Because we want to avoid possible performance regressions, introduce
> this new function which is designed to be public.
> 
> Suggested-by: Vivien Didelot <vivien.didelot@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
