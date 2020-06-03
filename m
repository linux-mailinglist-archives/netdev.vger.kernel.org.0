Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4DE1ED595
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgFCR6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 13:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgFCR6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 13:58:49 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31F2C08C5C0;
        Wed,  3 Jun 2020 10:58:48 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id v25so1152167uau.4;
        Wed, 03 Jun 2020 10:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0pDojOGUS4D4qIyqhe28pfrBON35mgEAOirwpgcuob4=;
        b=kw3Ae+Mu4UA8lpxW66uIpBN8ZvdPNyR2X5+dMfiVFr/YhceGmTLnWhnlZGRrN5Vx7t
         sL+zbyC9n4qgD+xh7ONpjMr0/bcVoMk1rY8y4DiWu7k8oJB7YxkTQD5bcRMBkGCR1fXu
         qKgIp/or/ebA/rj5e8l3aKISIEE1oPIpXGG/kkpJRAC3Ea+y6YmRkq1Mb28zVi2t3B0W
         bdQtP9bJLyBiotX6j6s81wjZTeo2J5WAnRyZroidCccot56CbW+yFYKj7bP3ah2hAv2E
         CiDNCFbQBiQdJanyVMJxHlplv8k7gqVpCrmQLIk3YXorxxJzZVQKSMAXF1Fw8/ZsoaBG
         Z21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0pDojOGUS4D4qIyqhe28pfrBON35mgEAOirwpgcuob4=;
        b=oENs0JY2dP1rSVhhxN3Sl3IRz/N/nUum/MKciu5KvbCQ8Wb99U6XDUyQQAo+gXKSaz
         i+OkMVkwXc1rOcoomEzDMe7kwi34dWIw9jO6lm/6k776EKA9j+2ppfZVTS5svYCnIsrB
         m6a1MF09aFDzPQ4LDZP5BMA9++SQl8RwvQxQTHG+VN42capUgTCkaRTKi0wfmQLqXvaA
         XceCzZQYE8Suw7OatRYNjkUKSQ7XzqJKEfYy29sDwy6WEGCJnTMlAb1GLBb8k1VOLTGc
         y/38wD0Xr+mSfw25SAK8VUHUZGpT2BMS+s9zefyVJD/f6KlvFmOr0JqTGDt2hELeH3Ae
         gBbQ==
X-Gm-Message-State: AOAM530kaE+q1UlkJlizpuMvL1Yq/25s8JWU9L2vBdFkDBPsVgVswuPc
        0DHIhei/Ml/BkIAlA2w+hIabN8w0MC6hgMEWhTcDESFRK4BWhQ==
X-Google-Smtp-Source: ABdhPJwPHkM/SKJcZo99n4bb9KDNLrGxouCrLqtW1gCGGZPQyppEJ+UMXEIgEuJtSdxjXPPrjRt3B5HSopVe3SQOKYY=
X-Received: by 2002:ab0:377c:: with SMTP id o28mr877590uat.135.1591207127894;
 Wed, 03 Jun 2020 10:58:47 -0700 (PDT)
MIME-Version: 1.0
References: <1591109785-14316-1-git-send-email-pooja.trivedi@stackpath.com> <20200602121947.40c99f51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200602121947.40c99f51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Wed, 3 Jun 2020 13:58:37 -0400
Message-ID: <CAOrEds=4XjgxPKxCk7jhZi7gMzjTLG9CAmWW2eSxA+cAgBxMKA@mail.gmail.com>
Subject: Re: [RFC PATCH net 1/1] net/tls(TLS_SW): Add selftest for 'chunked'
 sendfile test
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 3:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  2 Jun 2020 14:56:25 +0000 Pooja Trivedi wrote:
> > This selftest tests for cases where sendfile's 'count'
> > parameter is provided with a size greater than the intended
> > file size.
> >
> > Motivation: When sendfile is provided with 'count' parameter
> > value that is greater than the size of the file, kTLS example
> > fails to send the file correctly. Last chunk of the file is
> > not sent, and the data integrity is compromised.
> > The reason is that the last chunk has MSG_MORE flag set
> > because of which it gets added to pending records, but is
> > not pushed.
> > Note that if user space were to send SSL_shutdown control
> > message, pending records would get flushed and the issue
> > would not happen. So a shutdown control message following
> > sendfile can mask the issue.
> >
> > Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
>
> Looks good, thanks. Did you submit the change to splice officially?
> We'd need to get an Ack from VFS folks on it (Al Viro, probably?)
> or even merge it via the vfs tree.
>

No, I did not submit the change to splice yet. I can do that next.
I wanted to first run this through here and hear thoughts/suggestions.

> Minor nits below.
>

Will change and resubmit the selftest. Thanks.

> > diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
> > index 0ea44d9..f0455e6 100644
> > --- a/tools/testing/selftests/net/tls.c
> > +++ b/tools/testing/selftests/net/tls.c
> > @@ -198,6 +198,64 @@
> >       EXPECT_EQ(recv(self->cfd, buf, st.st_size, MSG_WAITALL), st.st_size);
> >  }
> >
> > +static void chunked_sendfile(struct __test_metadata *_metadata,
> > +                          struct _test_data_tls *self,
> > +                          uint16_t chunk_size,
> > +                          uint16_t extra_payload_size)
> > +{
> > +     char buf[TLS_PAYLOAD_MAX_LEN];
> > +     uint16_t test_payload_size;
> > +     int size = 0;
> > +     int ret;
> > +     char tmpfile[] = ".TMP_ktls";
>
> Could we place the file in /tmp and use mktemp()? I sometimes run the
> selftests from a read-only NFS mount, and trying to create a file in
> current dir breaks that.
>
> > +     int fd = open(tmpfile, O_RDWR | O_CREAT | O_TRUNC, 0644);
>
> We can unlink right after we open. The file won't get removed as long
> as we have a reference to it, and we minimize the risk of leaving it
> behind.
>
> > +     off_t offset = 0;
> > +
> > +     ASSERT_GE(fd, 0);
> > +     EXPECT_GE(chunk_size, 1);
> > +     test_payload_size = chunk_size + extra_payload_size;
> > +     ASSERT_GE(TLS_PAYLOAD_MAX_LEN, test_payload_size);
> > +     memset(buf, 1, test_payload_size);
> > +     size = write(fd, buf, test_payload_size);
> > +     EXPECT_EQ(size, test_payload_size);
> > +     fsync(fd);
> > +
> > +     while (size > 0) {
> > +             ret = sendfile(self->fd, fd, &offset, chunk_size);
> > +             EXPECT_GE(ret, 0);
> > +             size -= ret;
> > +     }
> > +
> > +     EXPECT_EQ(recv(self->cfd, buf, test_payload_size, MSG_WAITALL),
> > +               test_payload_size);
> > +
> > +     close(fd);
> > +     unlink(tmpfile);
> > +}
>
