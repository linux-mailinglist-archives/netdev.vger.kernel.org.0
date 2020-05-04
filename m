Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A191C46E0
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgEDTN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDTN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:13:58 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE141C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:13:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id a4so296225pgc.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 12:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=X/VwFo26Pw/Db4pYJ2P2RIJ4AtWBcC1vryD61pDIRC8=;
        b=jndQIXDHPKutguOtLvJZEHMOTtw4qGMK7UEll3bGD06Whrvsu42Ih9I1QD7/DR+Y1u
         8DkdGjvvTVNPMIZpQ+hTcovhCsQI54L7uvpvZslaeNbQbKR9IQI3yEvyeS+MyLJYyllr
         fjoaCECL+WawNlltU6JgIxCvrwaJpghstE20qHpdTrJj8kFvAtLbOasqg6POavUsz6a1
         dkxguHuILnH05wTDsYHkA+kaflrO/UxSYp2Evfp6AAFJm3L1bZWuA254NVFOxeEOLS9T
         qp0dBdg4kLb5jMR/8ow6coCoJ6UFTypR2Skz4B0NvyVlVXRfW8IWBIKk00Yii99dCzcw
         0qGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=X/VwFo26Pw/Db4pYJ2P2RIJ4AtWBcC1vryD61pDIRC8=;
        b=RFvqleKtGIGYQzBxKiBOHYHBncoMe02WsFi15978MbjQl7rjRWm6Cs4dz2gMmD3OAN
         sLZhfMu2C0hGcpYlLg7aPfbu+CgSNLiauYpw3rAxqZMVBqXr1XiseVdtpYrfWuydG0q4
         11UYnTwV5xQeGlQAixfew7auw1iE1hlql8ozSQ2pP1X5Ac9MR2DwKoDIVYVur/Pbn7UL
         WpB4DYPZKhVc9pMLqapWmtzULaQx/C8SCFPGPrccbTzJYXllBPRKv1Poon5vZ/UT296c
         pS4hRcrdthB6NsMDUSA1/6d+ZYjXgyGePRLI7AQS9MWsdrs8nQXV3ILnj8IIe73UvoNO
         TW7g==
X-Gm-Message-State: AGi0PubpCpxUuW4ADnkSojoM6vNrsnawXJ0YLyaWqgNLblZ4Oa6/HbvF
        BUXyTEf64LLWYfTx5ZNU/w0=
X-Google-Smtp-Source: APiQypJIsrtJzk5ohIQnd4h5HkfFL/2/7cg+fzrdmmMxey+rQXD2zTUtlLqZHrVM97lBDviRMz2fTw==
X-Received: by 2002:a62:ab16:: with SMTP id p22mr18322358pff.216.1588619637518;
        Mon, 04 May 2020 12:13:57 -0700 (PDT)
Received: from [100.108.141.115] ([2620:10d:c090:400::5:f6dd])
        by smtp.gmail.com with ESMTPSA id o99sm224072pjo.8.2020.05.04.12.13.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 12:13:56 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] xsk: change two variable names for increased
 clarity
Date:   Mon, 04 May 2020 12:13:55 -0700
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <BF768ECB-A68A-464B-B70A-780B68F356C4@gmail.com>
In-Reply-To: <1588599232-24897-2-git-send-email-magnus.karlsson@intel.com>
References: <1588599232-24897-1-git-send-email-magnus.karlsson@intel.com>
 <1588599232-24897-2-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4 May 2020, at 6:33, Magnus Karlsson wrote:

> Change two variables names so that it is clearer what they
> represent. The first one is xsk_list that in fact only contains the
> list of AF_XDP sockets with a Tx component. Change this to xsk_tx_list
> for improved clarity. The second variable is size in the ring
> structure. One might think that this is the size of the ring, but it
> is in fact the size of the umem, copied into the ring structure to
> improve performance. Rename this variable umem_size to avoid any
> confusion.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
