Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB6A6EA63
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbfGSRyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:54:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38249 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfGSRyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:54:05 -0400
Received: by mail-pg1-f193.google.com with SMTP id f5so5953511pgu.5
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T1Q017nVh+YI3rs6ulzgr5HhJfrnWU50XYPzQ4zZnSI=;
        b=UANDOAmytKRJ/de1Ku8gZx/EGBPnWVb+jXXmPodjeRUsn/WqMIbXho/B5n1ppVLJY1
         HMIWBmC5+H/sNvPhC7EmMGy+uxSXgFtY2WrTfNCpttuMY+7jrkVtsNznKIOO25yKtza4
         6D6954GjILtu1NY+ER6wFqecdnWvt/V5hJE6lAWbkJh73YujFHRylRQkx9e6W9pX8Aaa
         UQ6hUEckCo9PjAWTL2Z/OLufZcpUdiIF2vxWteWqff5g1SnusPgGuOU4fVAF9VItPyPX
         j2NoNAtWKXq3YLq56ocfcTQoDWkV/ypEkwugm/cfRu1tiV8kw8F/IjrsPexInF3kUSPH
         7cSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T1Q017nVh+YI3rs6ulzgr5HhJfrnWU50XYPzQ4zZnSI=;
        b=FOnGEZ5ovANKhLQNbjPP/0rblP61cWXjfqDPzBZomTUUIdFVALnPHSMK/sxiNZYd/3
         KdWD/tgKwdOPIfU2tjbFlsuVxL3xlrHffeY62VbySJdaYoAXXRKv8+PbcIL02q67xgnI
         +S3tZ5+OiBIDZGWTDkbTf4hitpyvtoiUP48BPdmCuMl5hSzksqZmf5jgdZWvUP7+QM0A
         5iRAimgBSvOcCjUrdt6/Ol69pSz9iWkXpElapM7fp0SWoU8a29ddIK4DsReGgCmMhmIo
         7dyFmi9Fi9CC2I7fFPAbGps8nRjhkw0zV5UjavK+WhcYOnPDNzjFQSEgp2ygbTBKRqQh
         /aiw==
X-Gm-Message-State: APjAAAWrpSobTdQZ4OeOCt3dd/7uO2eu3scYAnHMGhEBeUH3df0d1avk
        RHoPqPc9rY8dKWu/lwEXSmI=
X-Google-Smtp-Source: APXvYqytmuCcgYRo9HYbocoEcpd2gdnDUybCCEeJ5RrxJNBIWRIDuGuXnZYfiIagXa2gzYVmC3o/GA==
X-Received: by 2002:a65:5304:: with SMTP id m4mr54886715pgq.126.1563558844982;
        Fri, 19 Jul 2019 10:54:04 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h9sm40527226pgk.10.2019.07.19.10.54.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 10:54:04 -0700 (PDT)
Date:   Fri, 19 Jul 2019 10:54:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ivan Delalande <colona@arista.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] json: fix backslash escape typo in jsonw_puts
Message-ID: <20190719105403.371ed829@hermes.lan>
In-Reply-To: <20190718011531.GA29129@visor>
References: <20190718011531.GA29129@visor>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jul 2019 18:15:31 -0700
Ivan Delalande <colona@arista.com> wrote:

> Fixes: fcc16c22 ("provide common json output formatter")
> Signed-off-by: Ivan Delalande <colona@arista.com>

Applied.
