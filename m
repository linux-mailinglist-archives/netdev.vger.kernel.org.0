Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3557C108206
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 06:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKXFcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 00:32:42 -0500
Received: from mail-il1-f175.google.com ([209.85.166.175]:43510 "EHLO
        mail-il1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfKXFcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 00:32:42 -0500
Received: by mail-il1-f175.google.com with SMTP id r9so11124193ilq.10;
        Sat, 23 Nov 2019 21:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=BWpF7eTNZZUDhfMcmymaRHjNDWReQsXmHHPwFlsJAB8=;
        b=eYfVQvNOIGJqIwgWlez1DhLLHIgDjxGcVu1Ml7Jz1gG8sg0wz2JW+NSnr7lh9vAoI7
         udOTq8NxoSS0yv4F7xQVLTqY23r1UGixW7VNNJMxyHHJHrRxDGh7W2gaffzRV16zKnSV
         pLTnN64ObbG9y4WI1WsXUmkyCh/9QgA9W5UtsXjrbr6ExSzJ23O+NYfo5aVwATR5pZtw
         +F3W3oo7m3xYA2TuLT2AE1O0omTuFY/oXaDo3K8wy9LYVIaw9P55skpEAAtwdNzHJZai
         PCMZMaIVjoycK9IMG0hd9OOlxq2b0iDjVXX2ft4hv3B7uBhvnWXc/Zn7gR2N/Imuc6GF
         i0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=BWpF7eTNZZUDhfMcmymaRHjNDWReQsXmHHPwFlsJAB8=;
        b=hmtfxxFdi4G2Hdy7sR7Lm6HBrXopgZjSJLMsFgU4b2gXU0GsE1D5ctGcW6/iExIV0z
         Fj1dVCih3QJJgO/A3D6SmUMrawI5vWHZBDLY3yZpG0uXaylDyTOAxXcrYt7hy4UAefS3
         V09O6pjCpNMfw2wk5wvFd26B8Sf22dHNmZdG8eThoAI4Ksug+zl4CqO3HoI5Bh8g2Pnn
         qTUdlr4bzNs/n/UIAtR8TLSazsoogt3gkSF7U5HGobo14rW38ND2W8cXIAiOCBcSvToz
         9fW7eOlZzUSXBeqo85GBSkfPCx2oJhy44buUsjSs7SLDg0YQUv2Jm2tVjABxDW295fHL
         gkmQ==
X-Gm-Message-State: APjAAAU8yGDsbetvTGiKjD6T8yxqDPnCIBYjVoQuycUWiJ/TbZnfYfI2
        sXApLRPKeHlJx3QNjff9VHc=
X-Google-Smtp-Source: APXvYqwI9ZUw3+dyOS+bqMEyCjD5vI76ODMC6UCVewwoGzlodKXDXdOV0hlk3uKPRvUBFGCVohRAsA==
X-Received: by 2002:a92:868f:: with SMTP id l15mr26945963ilh.199.1574573559928;
        Sat, 23 Nov 2019 21:32:39 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h14sm926875ilc.87.2019.11.23.21.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 21:32:39 -0800 (PST)
Date:   Sat, 23 Nov 2019 21:32:30 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5dda15eeb5e1_62c72ad877f985c4c9@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123110751.6729-2-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-2-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 1/8] bpf, sockmap: Return socket cookie on lookup
 from syscall
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Tooling that populates the SOCKMAP with sockets from user-space needs a way
> to inspect its contents. Returning the struct sock * that SOCKMAP holds to
> user-space is neither safe nor useful. An approach established by
> REUSEPORT_SOCKARRAY is to return a socket cookie (a unique identifier)
> instead.
> 
> Since socket cookies are u64 values SOCKMAP needs to support such a value
> size for lookup to be possible. This requires special handling on update,
> though. Attempts to do a lookup on SOCKMAP holding u32 values will be met
> with ENOSPC error.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
