Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8ACD51C541
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243721AbiEEQnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiEEQnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:43:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A730580DE;
        Thu,  5 May 2022 09:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD9A0B82E08;
        Thu,  5 May 2022 16:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9EBC385A8;
        Thu,  5 May 2022 16:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651768779;
        bh=GBXigcmNZ6oOn9FevkRokCy3qepznYTUsv2xJiimIl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ut2f2uWjvBhhVRVR4NRdJXuyTTf9QAxePd4HC5EVHI7fhBzaDBKpX++IvnSnuPQwz
         eQ4/hHwUE4NHoPQsThPFTkXyPkT5h3uiKbQ0GQLkVwUUlwAL9o1QEfcvl12wHw9jnC
         38o+fGeJ4tA63JRmsQTFUWcONUVI/wcjF7+YkZyYCtvADZGhv3APyKD9igryOlKbCY
         vRfI2+/BUto/ADMC7B3bWo2pCiMpbTGJHnsu47Q2AfEaWb0hCwMiDj+4dgjNlVRMEn
         AcW9RpKGEDU6wJ5N5wLx62gbShhetgWJeaZmULspwTiQL0SD0IKJLthqzlqcsVdVUt
         X20i7NbU+HMlg==
Date:   Thu, 5 May 2022 09:39:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Allen Pais <apais@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFm?= =?UTF-8?B?YcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 1/1] firmware: tee_bnxt: Use UUID API for exporting
 the UUID
Message-ID: <20220505093938.571702fd@kernel.org>
In-Reply-To: <20220504091407.70661-1-andriy.shevchenko@linux.intel.com>
References: <20220504091407.70661-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 May 2022 12:14:07 +0300 Andy Shevchenko wrote:
> There is export_uuid() function which exports uuid_t to the u8 array.
> Use it instead of open coding variant.
> 
> This allows to hide the uuid_t internals.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> v4: added tag (Christoph), resent with 126858db81a5 (in next) in mind (Florian)

Judging by the history of the file this may go via the tee tree or
net-next. Since tee was not CCed I presume the latter is preferred.
Please let us know if that's incorrect otherwise we'll apply tomorrow :)
