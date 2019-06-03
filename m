Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6273D32FCD
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfFCMjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:39:01 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40340 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFCMjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:39:01 -0400
Received: by mail-qk1-f194.google.com with SMTP id c70so243331qkg.7
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 05:39:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2sjk4DZp0jJh29zFaVGsg/NLrYGXRIx+gqbhrU3b308=;
        b=ilFbgy7frDDaEKYp1hKaUV1vwYVdTC2OJc262IRMqUBSi4fv6lfglj7A8xy/JNlUPq
         N0+Xt14S3U48PfjhiSgO+jpjcyMMI+ndhHlYIl9gr2f6CuwWy22MruTlPo87talbYcP8
         egJ+hwwcFReo2dfmg1MORb0waZctNK8D1b3f3EzXaSk0AUDUeY2yFRpNrFqkYFt2l4Yk
         cuqimRTdyutdARPuj4bXcJRwYb1hywvON/EacGShGqkSMPS8rfECiS4dpEYyds9zZZAZ
         sv6VbXt5zShdDmWwN+ivV+ZjzVAV4coMfNyQOLWhQGfkdXo10oKnKMJdTWr4tro9hOcd
         YTtg==
X-Gm-Message-State: APjAAAVTLYMqAKRC3RQgszRSpfB7p8UNZEv4cJ3xQZyAzCCv7w7OqTLv
        i/Pu7Os2MCxFZEnT5hWIFjZ+LsyNuUMA4EKzu+k=
X-Google-Smtp-Source: APXvYqwF3nCClTIJso5yc+GR6oQ5XHY5i09CBSNlMjWFJ2mRIJkxpz8C9hB6hMWWZsn1E19dNP9eBYoE5o1aKE2fpL4=
X-Received: by 2002:ae9:c106:: with SMTP id z6mr2626266qki.285.1559565540179;
 Mon, 03 Jun 2019 05:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <201906031939.e6qlcBmD%lkp@intel.com>
In-Reply-To: <201906031939.e6qlcBmD%lkp@intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 3 Jun 2019 14:38:43 +0200
Message-ID: <CAK8P3a16QW6et2v4AihnwuKgz7JaTUhR9tELknUechjLemwjGg@mail.gmail.com>
Subject: Re: [net-next:master 391/455] drivers/staging/isdn/avm/b1.c:163:49:
 sparse: sparse: incorrect type in argument 2 (different address spaces)
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, Networking <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        gregkh <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 1:40 PM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Arnd,
>
> First bad commit (maybe != root cause):

Yep:

> >> drivers/staging/isdn/avm/b1.c:163:49: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1> *from @@    got  const [noderef] <asn:1> *from @@
> >> drivers/staging/isdn/avm/b1.c:163:49: sparse:    expected void const [noderef] <asn:1> *from
> >> drivers/staging/isdn/avm/b1.c:163:49: sparse:    got unsigned char *[assigned] dp

I only moved the file, so the warnings are now for a different pathname.

I'll leave it for the staging driver crowd to fix them up, or ignore them as the
driver is on  its way out of the kernel.

     Arnd
