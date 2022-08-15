Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6949B59499E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 02:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbiHOXRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 19:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353405AbiHOXQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 19:16:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200D01481E7;
        Mon, 15 Aug 2022 13:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=T7jm0kgaaNNjTArXwvvZufaSF+MSDx+bQ2hDSuAIXF4=;
        t=1660593793; x=1661803393; b=evMb4b7j/oUaHx78g/1j2W05KoN5kJ7kaHFpw2DOwGWeEaG
        Fa46x1FYPx+TOv4391R14C+Sja55ZshoFv9PWL/QcfBnRPxlQIFa9cpHgu1Hrsmo/dPCNzIx5W717
        glZUteh215T2OKiwQLXENwmXCywHjk+MMErPUW1LJ2O7qrlcIF4BZdw1jnXscYZmXRMc3i2NJd83X
        rG3gpaAjICG9IHbymp49yz76fNe8Loj0bmQ6KVkn29yMeL+0ysJSQcTHNClikmZhEmhwS95Topx2D
        vQaGB2G2lB1AznelIB0/bBsaKIogKqsMfudHcYf8hkoej2EhZMc/HTF039iL1/tg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oNgIf-008ofP-0Q;
        Mon, 15 Aug 2022 22:03:01 +0200
Message-ID: <73397c5c9a15e09e44eb696a73c6df2038ad8e25.camel@sipsolutions.net>
Subject: Re: [RFC net-next 2/4] ynl: add the schema for the schemas
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        jiri@resnulli.us, dsahern@kernel.org, stephen@networkplumber.org,
        fw@strlen.de, linux-doc@vger.kernel.org
Date:   Mon, 15 Aug 2022 22:03:00 +0200
In-Reply-To: <20220811022304.583300-3-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
         <20220811022304.583300-3-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-08-10 at 19:23 -0700, Jakub Kicinski wrote:
>=20
> +        subspace-of:
> +          description: |
> +            Name of another space which this is a logical part of. Sub-s=
paces can be used to define
> +            a limitted group of attributes which are used in a nest.

limited

johannes
