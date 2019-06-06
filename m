Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F5037D73
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 21:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfFFToZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 15:44:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36467 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbfFFToZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 15:44:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id a3so1930930pgb.3
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 12:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7h/E+dEZek7JnxJ6K+YYC5Yq5v6afqmdWBKSLiBmu6Q=;
        b=M39NX/G8LXc4gAVNjM2OZujMh+6OC1JlzW8RYdB2EFFhZMCCN6Nfsyb89RrPJ48CAv
         0EF1rBCnk0c/15KzIL1mtusLNVQ1Ij+LNcPtGy6I1PfHK81cvBJYQWtwRM37Cy6Rtprq
         JVCkDR4UO8swV8iBSxyuQZqwi7BU/nWi7pPv2+LyK9o9F6Pe20lTFCxEMjZHhTKA2BMM
         L1PJt55gqPWBQreNARfVDBQ2K30kekG7AHD1w0zEWqVHNef4zqeMjElAIlxXLmZY9hIm
         +ssOo64nGaHBeYrqJ4C4907rydJbZ120/o4vKLAEwrLiS/u8yAZBqIFsI/ASKFU/4nYz
         hIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7h/E+dEZek7JnxJ6K+YYC5Yq5v6afqmdWBKSLiBmu6Q=;
        b=N+7Uex3HHc5D7WhJD0D5icVwESIs0whjWTTYb1YJ6fC3/28XLE2+dd27Djt8y38u+q
         KUraIiXrEjPv60XqvmzEFaAY9L1lT0gxxBdLq7G307wiQNuOcNp/4+vw2/FE3f2i5hF/
         9tZozD3NGlV1fJHfe+wk/leSenSS6hb+ouqjyIh26cERcZZpmSsd2yV9FM8gAJrNU/Ir
         CjFxN0xzxeijyKPaD/WcJQkCV6b5MKR1S7MjppmchX5aZJbKZ/Kr5EtQkGs3jwQRvN6E
         k7Q37lMDvmKZ+chVN9cpkKrW4vk62CL5nyrLf+25fu9QRXx4W0dolWU7aUn830PEKweS
         dH0g==
X-Gm-Message-State: APjAAAUZUFbr1D5b8cKK4Mz6l++C+JkKdVVVJlDdeI6iW6ZzdHV0gLSz
        gGmIVtTbHNEMgoyZ0CUxMkEzFA==
X-Google-Smtp-Source: APXvYqxCyNkSkbjEFan1f20vIRbixKkIzSKXBckR/hgpjtPyJNlHor+KVDuA38ZQEMZ04SA8BzF4zw==
X-Received: by 2002:a17:90a:9dc5:: with SMTP id x5mr1464877pjv.110.1559850264383;
        Thu, 06 Jun 2019 12:44:24 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p64sm3000003pfp.72.2019.06.06.12.44.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 12:44:24 -0700 (PDT)
Date:   Thu, 6 Jun 2019 12:44:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vedang Patel <vedang.patel@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com
Subject: Re: [PATCH iproute2 net-next v1 4/6] taprio: add support for
 setting txtime_delay.
Message-ID: <20190606124422.3f34d07d@hermes.lan>
In-Reply-To: <1559843541-12695-4-git-send-email-vedang.patel@intel.com>
References: <1559843541-12695-1-git-send-email-vedang.patel@intel.com>
        <1559843541-12695-4-git-send-email-vedang.patel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jun 2019 10:52:19 -0700
Vedang Patel <vedang.patel@intel.com> wrote:

> +	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY])
> +		txtime_delay = rta_getattr_s32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
> +
> +	print_int(PRINT_ANY, "txtime_delay", " txtime delay %d", txtime_delay);
> +

Once again do not print anything if option is not present.
