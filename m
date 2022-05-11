Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC1522A38
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240280AbiEKDNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbiEKDNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:13:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B00F48330
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652238815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dQ1Fyk50JgdV+EdhZRZzCXVto8lXq6s2xXInfURVdaY=;
        b=jKIsiVwogDwvhszIa1wk90aZiXUzpOySwPSkFc5QCF+HBIDPK6IzH8g+MEwWHvBMazzEX+
        RDT8EMiXwx/b9msjwnaV4Pt03UB3FTzGfRAYvLs2rJqqJpUmjrHfA6s2QbqHVnv2B/9hBp
        CA34zAQktlqn18mOuHXoEGSHxtAlEnE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-Th3dvIM9P1SGILfpkfz56w-1; Tue, 10 May 2022 23:13:34 -0400
X-MC-Unique: Th3dvIM9P1SGILfpkfz56w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FD01101AA42;
        Wed, 11 May 2022 03:13:34 +0000 (UTC)
Received: from Laptop-X1 (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 826C77AD9;
        Wed, 11 May 2022 03:13:31 +0000 (UTC)
Date:   Wed, 11 May 2022 11:13:26 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
Message-ID: <Ynsp1nEle4y3UBmB@Laptop-X1>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
 <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com>
 <20134.1649778941@famine>
 <Yl07fecwg6cIWF8w@Laptop-X1>
 <YmKCPSIzXjvystdy@Laptop-X1>
 <YnTYUmso0D29CDcg@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnTYUmso0D29CDcg@Laptop-X1>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 04:12:09PM +0800, Hangbin Liu wrote:
> Hi Jay,
> 
> I'm still waiting for your comments before post v2 patch. Appreciate if you
> could have a better way about handling the slave name in options management.

Hi Jay,

Would you please help reply when have time?

Thanks
Hangbin

