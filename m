Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B770B6DF6AA
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjDLNNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjDLNM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:12:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571E27D9C
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681305112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1D46JFxA1D4wfFupMcnYoarGsIZHFjfP9t+uj+x7BJI=;
        b=JBbqP9W1EOQi8qk70fcAAK9RX7cuIAdGYRRsndJKEJqvgDP3bP3Vxb6+BcPHvPsXUMatek
        hnLhOjKkylVXsoT5TDcKBUVpWOl0yBYKAc6sb9eHtoZkVC9AA1GirB4D/GCU6JxKPJGkFl
        o5HdYxAME6q1zREWwjv0n4hRQzNZ6Ak=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-ZX23SFyfND67XerYwxVyWQ-1; Wed, 12 Apr 2023 09:11:46 -0400
X-MC-Unique: ZX23SFyfND67XerYwxVyWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 875253C0F66C;
        Wed, 12 Apr 2023 13:11:46 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E38C52166B29;
        Wed, 12 Apr 2023 13:11:45 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id B20E9A80BFF; Wed, 12 Apr 2023 15:11:44 +0200 (CEST)
Date:   Wed, 12 Apr 2023 15:11:44 +0200
From:   Corinna Vinschen <vinschen@redhat.com>
To:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Message-ID: <ZDauEGjbcT6uPfCp@calimero.vinschen.de>
Mail-Followup-To: netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
References: <20230411130028.136250-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411130028.136250-1-vinschen@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apr 11 15:00, Corinna Vinschen wrote:
> stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
> like TX offloading don't correspond with the general features and it's
> not possible to manipulate features via ethtool -K to affect VLANs.

On second thought, I wonder if this shouldn't go into net, rather then
net-next?  Does that make sense? And, do I have to re-submit, if so?


Thanks,
Corinna

