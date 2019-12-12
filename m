Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F174D11D778
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbfLLTwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:52:33 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33668 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730638AbfLLTwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:52:33 -0500
Received: by mail-pl1-f194.google.com with SMTP id c13so1112377pls.0
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 11:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5NlgtfdKs6MHr85VVv97LVkhCSDCmeYWhwBWV6Mr5n8=;
        b=JFLVQdQhhcw5MlS8Yw7XBqCYbUdNuPsVkNpxRR2PMWTVs5l+mdSQ/dTLtpuC6Erz9W
         LOuVDkd6NnlJ7u5TE214XPI/5e1V8YZw//XcT6E0g6m12sogwLgfc8k52w5iwOWwS+GD
         fCyp9AQLrAIbWz8022onyJHvQhZa3sGufeTBGhiFFaB8INZrRKSXW5TjnaeIhupoeyOp
         qdA62O5ZJw8852HlT2ysCnBG3DvhJ28sTYDnbN6ggMVDQaYDudj/dmzJeoJFNbtF6jw9
         dO07VyWQiibffphuMYjIDBozmlw4QI1WF6/q7t5rWAr7lFAGhUHn6qsDHo0MfYcIyXOn
         Rn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5NlgtfdKs6MHr85VVv97LVkhCSDCmeYWhwBWV6Mr5n8=;
        b=qNnQQzzWAWdWwi73ZH3cFJvtFC7rq79BBnHAH7kIeqJfuKpOGe22FQinjC1hEqBkq1
         GSPSi0hk07F4NUtdX4VpYAXtcHYMNr3RYHpRI8Vw8AI/mNHKSmTq5CAKOouqDJ2ihCmP
         TR6uj6yZRJl5Nat2+n/FwQA1XpzTeKpxVic7hMd/OEVGHPKk4JcoBuhl18EZiz+/DLwa
         sjWDq9CEh0z2WUWHhmD3dghSPZza8Inpkzz8sQPf6+60GTGFEODdbz+QqqQy2A601dPk
         BzhFFS9F/+XeD2DJT/ykZ3KVZZHzpU0MvDOdGXQS2WpeU4oXktBaS6WuueqBjK6e2y9c
         NaCQ==
X-Gm-Message-State: APjAAAUk4SSJ7yoeZODhSLzZbPxT5SbujFd7relYeMBy6k0eI2oKnn0t
        tqKWgKLxhJyUOqVDjE0fB9nHhjiQj5Y=
X-Google-Smtp-Source: APXvYqxpgWuVwK162fIyjli578eHCl3lb9o6o3JL4VU65LWAJTvf1e+GqWtjvlA/XBq9gOTktr2OpQ==
X-Received: by 2002:a17:90a:9908:: with SMTP id b8mr12202600pjp.89.1576180352718;
        Thu, 12 Dec 2019 11:52:32 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j125sm8501926pfg.160.2019.12.12.11.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 11:52:32 -0800 (PST)
Date:   Thu, 12 Dec 2019 11:52:28 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Shannon Nelson <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Message-ID: <20191212115228.2caf0c63@cakuba.netronome.com>
In-Reply-To: <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
References: <20191212003344.5571-1-snelson@pensando.io>
        <20191212003344.5571-3-snelson@pensando.io>
        <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 06:53:42 +0000, Parav Pandit wrote:
> >  static void ionic_remove(struct pci_dev *pdev)
> >  {
> >  	struct ionic *ionic = pci_get_drvdata(pdev);
> > @@ -257,6 +338,9 @@ static void ionic_remove(struct pci_dev *pdev)
> >  	if (!ionic)
> >  		return;
> >  
> > +	if (pci_num_vf(pdev))
> > +		ionic_sriov_configure(pdev, 0);
> > +  
> Usually sriov is left enabled while removing PF.
> It is not the role of the pci PF removal to disable it sriov.

I don't think that's true. I consider igb and ixgbe to set the standard
for legacy SR-IOV handling since they were one of the first (the first?)
and Alex Duyck wrote them.

mlx4, bnxt and nfp all disable SR-IOV on remove.
