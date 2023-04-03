Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D62D6D54AB
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbjDCWU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbjDCWU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:20:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D17D2D7D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E0A162CE9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 22:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7B6C433EF;
        Mon,  3 Apr 2023 22:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680560454;
        bh=pvAng7h2GiVpbsii7yUXsD7CnnBM0WD9INMhxQ4f9oc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gJj8v2ns04e+YIClJMlw7eMueHRk5lNT4PUJUTy6TxBQVcXKFRzS2D0UH7CBpJC2V
         TQBRmYBKkCM0DmzKkkLMC7ypg/ieEjFssteZDFXr0MZFKFuGZj4871XcZB9pLO1H1d
         E74iYYLF4tTsRXOtrTbXfOY4lfCCIaxMzBqcaXfMhqtWX5A36LP0lbi4U4NOcC4EtT
         KVraOzl7ktcMdlxYKa+9pI0SV2es56UOW2E6y9L+2Y5ocEMLMLK/WMfUtOPIi6hGPq
         +6UCNWz00cLsNN+k1q/TysjkbpEx4AQrlWCfJaccsmlxKlAQLo8PSMwxfjbeyc5sUi
         aO87Y85Y1zvlw==
Date:   Mon, 3 Apr 2023 15:20:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 01/15] virtchnl: add virtchnl
 version 2 ops
Message-ID: <20230403152053.53253d7e@kernel.org>
In-Reply-To: <49947b6b-a59d-1db1-f405-0ab4e6e3356e@amd.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
        <20230329140404.1647925-2-pavan.kumar.linga@intel.com>
        <49947b6b-a59d-1db1-f405-0ab4e6e3356e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 15:01:55 -0700 Shannon Nelson wrote:
> > diff --git a/drivers/net/ethernet/intel/idpf/virtchnl2.h b/drivers/net/ethernet/intel/idpf/virtchnl2.h  
> 
> If this is to be a standardized interface, why is this header buried in 
> the driver specific directory instead of something more accessible like 
> include/linux/idpf?

The noise about this driver being "a standard" is quite confusing.

Are you considering implementing any of it?

I haven't heard of anyone who is yet, so I thought all this talk of
a standard is pretty empty from the technical perspective :(
