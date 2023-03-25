Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94F86C8AAA
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 04:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjCYDfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 23:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCYDft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 23:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0912517CE2
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 20:35:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F94B82618
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 03:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076BAC433D2;
        Sat, 25 Mar 2023 03:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679715344;
        bh=6YQ2zIUZM1ybhZb1JKZClfRyRw6Yt60Ce33S2lEJecc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p0mmMXeFF40eVJWsR7XNomA86QRBeeP4tauAAysyZMxyk2zSffPT/QlRAxD6AlJql
         kN2fohD0TZ+eqmso+l18gwW4o2M8tum6PlKCEckzT3NX70mdgEGMM2xSMtxvlo4ggp
         iqjhnVvQkdu/j5wd2eHXFoVRIMqmoz2W3oyQVr5IC2GmdZEVwqQSdU7Osv1Sibjrml
         UH9Tus7wuItrBH5ZyGJjjtbofTIAeHSMaPl+9bfvATP0siWt1D8SaRZIFifJQEIOn6
         M8wRYBdxwSbhdekoeXvcg/cgEvDWQegfHgrrFbNJDdZdiU9RfqzZQKNTKMMSTVNlM7
         tj6Fu2IAqWUdQ==
Date:   Fri, 24 Mar 2023 20:35:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v2 4/4] tools: ynl: ethtool testing tool
Message-ID: <20230324203543.3998a487@kernel.org>
In-Reply-To: <20230324225656.3999785-5-sdf@google.com>
References: <20230324225656.3999785-1-sdf@google.com>
        <20230324225656.3999785-5-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 15:56:56 -0700 Stanislav Fomichev wrote:
> +def args_to_req(ynl, op_name, args, req):
> +  """
> +  Verify and convert command-line arguments to the ynl-compatible request.
> +  """
> +  valid_attrs = ynl.operation_do_attributes(op_name)
> +  valid_attrs.remove('header') # not user-provided
> +
> +  if len(args) == 0:
> +    print(f'no attributes, expected: {valid_attrs}')
> +    sys.exit(1)

Could you re-format with 4 char indentation? To keep it consistent with
the rest of ynl?
