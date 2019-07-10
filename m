Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDCAC64C26
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfGJSfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:35:33 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46396 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbfGJSf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:35:28 -0400
Received: by mail-lj1-f195.google.com with SMTP id v24so3072606ljg.13
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=59LQqbVb+KQ/BMKWYDi9soPsvc3OIaSci70f6vwiQDg=;
        b=FqoWOUQDI8WMp245xx+rH6pVnDYOUvjDYs15fEQlF6pDz0NP8XsjV31N/mtE4tmezC
         j2UTUlQ1N7GdmP1kf74xSCxvIJJ+DHBtK3c6eKcgoseA+K8AhvGS/ovhJPv6+HASW4G8
         XOZuoCQHXi5bTBX95YG3a2jJFHuWkpZNYqeaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=59LQqbVb+KQ/BMKWYDi9soPsvc3OIaSci70f6vwiQDg=;
        b=SMXeb027vRdFETXGsVTOsSqCdOrkN8l0s9JURMsvIaWi/QYzvv1UcbTpOG4nENanRc
         4jzyzJ+Xjhz90WeAbZPg2qSezO1K/+ekJuY376xRq4+4n5PJoVFi0YMfjP1T+8AznSY1
         dhSnEYkAgMzYPeO2CnST0MyalXnzNWdiKY+f46UCTorhtil5mPwlh/kNkIijeW/siMUs
         HCVBDIKMbIqG3AitjX4ZoldCRsRkGZKK+PQVG5RcLxENtX0MKksLJlutYEdR0JYSfTqy
         wLl7frmWVMfFL7FrSt+sET+XJph4PD2nPrWHgDe0lpsCa75GUMt6GQGWCYLPG7YTjkQY
         IRHA==
X-Gm-Message-State: APjAAAVWBfRX26IrkQhXtM3MvTmSPqRGSFZZtJOaZYOVKdeTOem34T+0
        AbO48vyp8x74zwgqODeYUHaLmxMg0o4=
X-Google-Smtp-Source: APXvYqzFlHZwjukHyVfOTHvRjWArFE8dC/gdy2lxf8gY7MIGqYpMJtQn9D0wPt3+jqqLM44E7fq4Lw==
X-Received: by 2002:a2e:5c6:: with SMTP id 189mr18659159ljf.22.1562783725715;
        Wed, 10 Jul 2019 11:35:25 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id x67sm590257ljb.13.2019.07.10.11.35.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 11:35:24 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id u10so2268768lfm.12
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:35:24 -0700 (PDT)
X-Received: by 2002:a19:641a:: with SMTP id y26mr14803967lfb.29.1562783723934;
 Wed, 10 Jul 2019 11:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <28477.1562362239@warthog.procyon.org.uk>
In-Reply-To: <28477.1562362239@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Jul 2019 11:35:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjxoeMJfeBahnWH=9zShKp2bsVy527vo3_y8HfOdhwAAw@mail.gmail.com>
Message-ID: <CAHk-=wjxoeMJfeBahnWH=9zShKp2bsVy527vo3_y8HfOdhwAAw@mail.gmail.com>
Subject: Re: [GIT PULL] Keys: Set 4 - Key ACLs for 5.3
To:     David Howells <dhowells@redhat.com>
Cc:     James Morris James Morris <jmorris@namei.org>,
        keyrings@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        linux-nfs@vger.kernel.org, CIFS <linux-cifs@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 2:30 PM David Howells <dhowells@redhat.com> wrote:
>
> Here's my fourth block of keyrings changes for the next merge window.  They
> change the permissions model used by keys and keyrings to be based on an
> internal ACL by the following means:

It turns out that this is broken, and I'll probably have to revert the
merge entirely.

With this merge in place, I can't boot any of the machines that have
an encrypted disk setup. The boot just stops at

  systemd[1]: Started Forward Password Requests to Plymouth Directory Watch.
  systemd[1]: Reached target Paths.

and never gets any further. I never get the prompt for a passphrase
for the disk encryption.

Apparently not a lot of developers are using encrypted volumes for
their development machines.

I'm not sure if the only requirement is an encrypted volume, or if
this is also particular to a F30 install in case you need to be able
to reproduce. But considering that you have a redhat email address,
I'm sure you can find a F30 install somewhere with an encrypted disk.

David, if you can fix this quickly, I'll hold off on the revert of it
all, but I can wait only so long. I've stopped merging stuff since I
noticed my machines don't work (this merge window has not been
pleasant so far - in addition to this issue I had another entirely
unrelated boot failure which made bisecting this one even more fun).

So if I don't see a quick fix, I'll just revert in order to then
continue to do pull requests later today. Because I do not want to do
further pulls with something that I can't boot as a base.

                 Linus
