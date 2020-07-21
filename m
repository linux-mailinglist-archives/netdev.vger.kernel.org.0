Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BC8228335
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 17:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgGUPJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 11:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgGUPJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 11:09:45 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C192C061794;
        Tue, 21 Jul 2020 08:09:45 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 8so1146173pjj.1;
        Tue, 21 Jul 2020 08:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eoQ/LwxD/ih1GkSzZAuNDCG4MFgTBugN1T3/2DGPiZs=;
        b=KmcdvitIPM0ZFS7BiZAORytFknRF/NJjqwGhXJbcpyxRU5OsqYeFLMZBj7ZTICExgy
         QuzRkzTZlNMRcaqFb6yBkA1qKLOjKL3YvNFmeK+GiI2VI+UkKVbQDs+8D4oJSBPeUfio
         O60k7atldaQEfVM/eKAL52AIZkGkqgIaka6IV6wYrVZJJxxYn6bKNLnPru+gph7D44zT
         mFqXyyg7VLSctQnF0GY4kjhufYXEc3BmPiJuRbSM6mEfabaDcchfbcIN/W0G6vwyYVBb
         0cPUwTWccn+x+bDjxlzEyCBodaTCUHGo4KJxMufcROGt9iy/ySVyvWZPurM2Utyxr6rV
         FAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eoQ/LwxD/ih1GkSzZAuNDCG4MFgTBugN1T3/2DGPiZs=;
        b=F71wg+UihHvX0MdMzgQnAlhacghYS+rz1wqllPkPR2LfgI6ada6ZI8gDS/GaTVr/tF
         X8/Yncp1YwQVmeZrG7QepCIr9aI8Nqsfw+T8R3li4idPemvqPPXp59Fw32hahiK0u1YR
         6lnAcZF3XOo3+fKXHN4x9weQ65mRbowTWbeCLY1jkLjtuhRVmT3tpDCtLr8a/ULwskYd
         XREilWmz7r0ETZom7mOu2+/Tdc0zEvUDMPbGxfskjNpxCmvRCUurHLMsID1YNdYKezkf
         qeX5FS7/RmmRy5wn2oq9TZV4tO/2Ee+XHKRQGvQgQDqGZydLPXhG7JHVdtAuwMMXB2CZ
         4kKg==
X-Gm-Message-State: AOAM530CWP487WmM6B17nCXk+IlLRFfi1ATYoHF7lKuyyUtOJH85Zqaw
        Ri6rJ4BzMiJv6ni0LG6TSgU=
X-Google-Smtp-Source: ABdhPJz4/0wCZf0XMDAqiQz3adVwsAM+1tFiAJD4fUtW8v8r/Z0JnQYCFnNIOeXwwXGt/iVKX/DjuQ==
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr20461966plr.220.1595344184727;
        Tue, 21 Jul 2020 08:09:44 -0700 (PDT)
Received: from gmail.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id 22sm20312399pfh.157.2020.07.21.08.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 08:09:43 -0700 (PDT)
Date:   Tue, 21 Jul 2020 20:38:18 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jouni Malinen <j@w1.fi>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v1] hostap: use generic power management
Message-ID: <20200721150818.GA371967@gmail.com>
References: <20200721150547.371763-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200721150547.371763-1-vaibhavgupta40@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is compile-tested only.

--Vaibhav Gupta
