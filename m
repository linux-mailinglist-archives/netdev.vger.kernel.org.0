Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AFF52ADD1
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 00:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiEQWFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 18:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiEQWFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 18:05:48 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CC1134;
        Tue, 17 May 2022 15:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AqOwTe1WYDilo14XAd3xKHqdHGS/uTUyPBKfuE4y0GU=; b=asov2CXAoWleBDgblXMHkwDM03
        6tOIBvwyZ+ZOgZIst9Q7xbqMXazNnGiVmRD09yZK4GTD5dG2ZcxrJfQpiI0hqm2zuaZM8tSMslFE5
        mL+lLmYFvbfmXveMiaE4KPPVuGRZjFqUDnWv56JLkZT3Pk2GkhjwhcVBW3cTDgyxqsbVm9i9eOELH
        OUrs/PysJYtH+uotJPxbqcQ8UZRJDxohiwogO2OdfDYZcFRycs7ECvqN0+3sj1u6gatpn1+2spiyg
        Na7YqttJXM0vMI0s8gXqTvt29ycbf7pDLT/39REMfEU7xt5GFV8fyjPKZRjrErpFkTUWFngwBhYnf
        xZ4yI5ow==;
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nr5K2-00Fqdf-FW; Tue, 17 May 2022 22:05:42 +0000
Date:   Tue, 17 May 2022 22:05:42 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     akpm@linux-foundation.org, x86@kernel.org,
        linux-alpha@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: unexport csum_and_copy_{from,to}_user
Message-ID: <YoQcNkB6R/E3vf51@zeniv-ca.linux.org.uk>
References: <20220421070440.1282704-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421070440.1282704-1-hch@lst.de>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 09:04:40AM +0200, Christoph Hellwig wrote:
> csum_and_copy_from_user and csum_and_copy_to_user are exported by
> a few architectures, but not actually used in modular code.  Drop
> the exports.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Al Viro <viro@zeniv.linux.org.uk>

Not sure which tree should it go through - Arnd's, perhaps?
