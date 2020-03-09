Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843D717EA52
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 21:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgCIUnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 16:43:39 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40692 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgCIUnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 16:43:39 -0400
Received: by mail-io1-f65.google.com with SMTP id d8so10561511ion.7;
        Mon, 09 Mar 2020 13:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zEwQPc/cktw5tBhKv2kKnQO53Dvf0P2ufBKu9rHuoYc=;
        b=QBYMw1Dz1XPwjeeaDN8x/Bk4YHxr5xneG+rAq0lHtXaRi1QJU7cAMR6qkEvEb7uyOR
         bc5wYz4g48j5Spq0nYkuGD4KTVSUeH6r3Cjj0Bh5JFEGnzLQsGRv/5axG3VE344RukED
         VwzLtL/cd0NeaDbudYpnqnTQnBOQW9r3EYmJxb7fFaXM70uVlQZWUgg80g/d1+s/NCpm
         qWnBdFHanGIfKnlKEdEZQ58WEtu/wzBHdVFRg8Pu1lq23quddIdTj2mROic4I9TLqOeJ
         hBPMGpQtLJH4MCPDCcoN4iCSg2W0hjtpRrLwmNS8/JnJ3/wsnZhiU1NI9ZUStv8yhX2R
         G0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zEwQPc/cktw5tBhKv2kKnQO53Dvf0P2ufBKu9rHuoYc=;
        b=KJMzBNFdCUuAD+rFs9VYhpz7gq/5cuTSBgY1HdNgQFMoLBJQ/PfQ+sxKb9y/2Nyzcc
         8joWJc+ksDPCe2TrExnPSiDVMcnRhl8Vr+tc7nEOtytxBDcH4o62FbpvQvtbBZ7jO6Bb
         a7auEAdFHZ6zikPgIgEccGbMqmFAU+Bwpa4+7fxtMtrOe5woyxpE6VCfJN7OKorDANWs
         kXyiXDnJiYgsG3/vtB5VwgPNIJJG45onuGl6Y/rLNs6XpMFyxT4pqDotXWi8wbgEod2g
         mLCfM8Mf0WI6aapPnxLPSUOzCaI+77iMSsMZapHj3xWEOkEAMLuF5maUv4b6+bnXIHTH
         vp+g==
X-Gm-Message-State: ANhLgQ1VkyqQnPP0CgSWbI71EhJDqyGGxmviX89MaiRVH41++/GFUDTz
        S0OD+NAFVtiUO5lJLYlT2pi/m5rEB7K2QaZUZug=
X-Google-Smtp-Source: ADFU+vvMzT8bJfNNecqep/7MLiMSr1G9i/6zdh+cjkluFj7JLFQOIjQZik6Ccwr4QYLlE723I5Eu+lIlpg7skh+qR2s=
X-Received: by 2002:a6b:17c4:: with SMTP id 187mr15119603iox.143.1583786616498;
 Mon, 09 Mar 2020 13:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200303093327.8720-1-gmayyyha@gmail.com>
In-Reply-To: <20200303093327.8720-1-gmayyyha@gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 9 Mar 2020 21:43:36 +0100
Message-ID: <CAOi1vP8jZ2tX_dg90uZY5G8cKX2Lzyu2vrGT_Ew0gVsnK4DDMA@mail.gmail.com>
Subject: Re: [v2] ceph: using POOL FULL flag instead of OSDMAP FULL flag
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000adc5df05a0720e7d"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000adc5df05a0720e7d
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 3, 2020 at 10:33 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
>
> CEPH_OSDMAP_FULL/NEARFULL has been deprecated since mimic, so it
> does not work well in new versions, added POOL flags to handle it.
>
> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> ---
>  fs/ceph/file.c                  |  9 +++++++--
>  include/linux/ceph/osd_client.h |  2 ++
>  include/linux/ceph/osdmap.h     |  3 ++-
>  net/ceph/osd_client.c           | 23 +++++++++++++----------
>  4 files changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 7e0190b1f821..84ec44f9d77a 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1482,7 +1482,9 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         }
>
>         /* FIXME: not complete since it doesn't account for being at quota */
> -       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> +       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL) ||
> +           pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> +                                               CEPH_POOL_FLAG_FULL)) {
>                 err = -ENOSPC;
>                 goto out;
>         }
> @@ -1575,7 +1577,10 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         }
>
>         if (written >= 0) {
> -               if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> +               if (ceph_osdmap_flag(&fsc->client->osdc,
> +                                       CEPH_OSDMAP_NEARFULL) ||
> +                   pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> +                                       CEPH_POOL_FLAG_NEARFULL))
>                         iocb->ki_flags |= IOCB_DSYNC;
>                 written = generic_write_sync(iocb, written);
>         }
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 5a62dbd3f4c2..be9007b93862 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -375,6 +375,8 @@ static inline bool ceph_osdmap_flag(struct ceph_osd_client *osdc, int flag)
>         return osdc->osdmap->flags & flag;
>  }
>
> +bool pool_flag(struct ceph_osd_client *osdc, s64 pool_id, int flag);
> +
>  extern int ceph_osdc_setup(void);
>  extern void ceph_osdc_cleanup(void);
>
> diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
> index e081b56f1c1d..88faacc11f55 100644
> --- a/include/linux/ceph/osdmap.h
> +++ b/include/linux/ceph/osdmap.h
> @@ -36,7 +36,8 @@ int ceph_spg_compare(const struct ceph_spg *lhs, const struct ceph_spg *rhs);
>
>  #define CEPH_POOL_FLAG_HASHPSPOOL      (1ULL << 0) /* hash pg seed and pool id
>                                                        together */
> -#define CEPH_POOL_FLAG_FULL            (1ULL << 1) /* pool is full */
> +#define CEPH_POOL_FLAG_FULL            (1ULL << 1)  /* pool is full */
> +#define CEPH_POOL_FLAG_NEARFULL        (1ULL << 11) /* pool is nearfull */
>
>  struct ceph_pg_pool_info {
>         struct rb_node node;
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index b68b376d8c2f..9ad2b96c3e78 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -1447,9 +1447,9 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>                 atomic_dec(&osd->o_osdc->num_homeless);
>  }
>
> -static bool __pool_full(struct ceph_pg_pool_info *pi)
> +static bool __pool_flag(struct ceph_pg_pool_info *pi, int flag)
>  {
> -       return pi->flags & CEPH_POOL_FLAG_FULL;
> +       return pi->flags & flag;
>  }
>
>  static bool have_pool_full(struct ceph_osd_client *osdc)
> @@ -1460,14 +1460,14 @@ static bool have_pool_full(struct ceph_osd_client *osdc)
>                 struct ceph_pg_pool_info *pi =
>                     rb_entry(n, struct ceph_pg_pool_info, node);
>
> -               if (__pool_full(pi))
> +               if (__pool_flag(pi, CEPH_POOL_FLAG_FULL))
>                         return true;
>         }
>
>         return false;
>  }
>
> -static bool pool_full(struct ceph_osd_client *osdc, s64 pool_id)
> +bool pool_flag(struct ceph_osd_client *osdc, s64 pool_id, int flag)
>  {
>         struct ceph_pg_pool_info *pi;
>
> @@ -1475,8 +1475,10 @@ static bool pool_full(struct ceph_osd_client *osdc, s64 pool_id)
>         if (!pi)
>                 return false;
>
> -       return __pool_full(pi);
> +       return __pool_flag(pi, flag);
>  }
> +EXPORT_SYMBOL(pool_flag);
> +
>
>  /*
>   * Returns whether a request should be blocked from being sent
> @@ -1489,7 +1491,7 @@ static bool target_should_be_paused(struct ceph_osd_client *osdc,
>         bool pauserd = ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD);
>         bool pausewr = ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSEWR) ||
>                        ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
> -                      __pool_full(pi);
> +                      __pool_flag(pi, CEPH_POOL_FLAG_FULL);
>
>         WARN_ON(pi->id != t->target_oloc.pool);
>         return ((t->flags & CEPH_OSD_FLAG_READ) && pauserd) ||
> @@ -2320,7 +2322,8 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
>                    !(req->r_flags & (CEPH_OSD_FLAG_FULL_TRY |
>                                      CEPH_OSD_FLAG_FULL_FORCE)) &&
>                    (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
> -                   pool_full(osdc, req->r_t.base_oloc.pool))) {
> +                  pool_flag(osdc, req->r_t.base_oloc.pool,
> +                            CEPH_POOL_FLAG_FULL))) {
>                 dout("req %p full/pool_full\n", req);
>                 if (ceph_test_opt(osdc->client, ABORT_ON_FULL)) {
>                         err = -ENOSPC;
> @@ -2539,7 +2542,7 @@ static int abort_on_full_fn(struct ceph_osd_request *req, void *arg)
>
>         if ((req->r_flags & CEPH_OSD_FLAG_WRITE) &&
>             (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
> -            pool_full(osdc, req->r_t.base_oloc.pool))) {
> +            pool_flag(osdc, req->r_t.base_oloc.pool, CEPH_POOL_FLAG_FULL))) {
>                 if (!*victims) {
>                         update_epoch_barrier(osdc, osdc->osdmap->epoch);
>                         *victims = true;
> @@ -3707,7 +3710,7 @@ static void set_pool_was_full(struct ceph_osd_client *osdc)
>                 struct ceph_pg_pool_info *pi =
>                     rb_entry(n, struct ceph_pg_pool_info, node);
>
> -               pi->was_full = __pool_full(pi);
> +               pi->was_full = __pool_flag(pi, CEPH_POOL_FLAG_FULL);
>         }
>  }
>
> @@ -3719,7 +3722,7 @@ static bool pool_cleared_full(struct ceph_osd_client *osdc, s64 pool_id)
>         if (!pi)
>                 return false;
>
> -       return pi->was_full && !__pool_full(pi);
> +       return pi->was_full && !__pool_flag(pi, CEPH_POOL_FLAG_FULL);
>  }
>
>  static enum calc_target_result

Hi Yanhu,

Sorry for a late reply.

This adds some unnecessary churn and also exposes a helper that
must be called under osdc->lock without making that obvious.  How
about the attached instead?

ceph_pg_pool_flags() takes osdmap instead of osdc, making it clear
that the caller is resposibile for keeping the map stable.

Thanks,

                Ilya

--000000000000adc5df05a0720e7d
Content-Type: text/x-patch; charset="US-ASCII"; name="full-nearfull.patch"
Content-Disposition: attachment; filename="full-nearfull.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k7kxn5bu0>
X-Attachment-Id: f_k7kxn5bu0

ZGlmZiAtLWdpdCBhL2ZzL2NlcGgvZmlsZS5jIGIvZnMvY2VwaC9maWxlLmMKaW5kZXggYmE0NmJh
NzQwNjI4Li5jOGQ4NGU5MGEzNzEgMTAwNjQ0Ci0tLSBhL2ZzL2NlcGgvZmlsZS5jCisrKyBiL2Zz
L2NlcGgvZmlsZS5jCkBAIC0xNjYzLDEwICsxNjYzLDEzIEBAIHN0YXRpYyBzc2l6ZV90IGNlcGhf
d3JpdGVfaXRlcihzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqZnJvbSkKIAlz
dHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZV9pbm9kZShmaWxlKTsKIAlzdHJ1Y3QgY2VwaF9pbm9k
ZV9pbmZvICpjaSA9IGNlcGhfaW5vZGUoaW5vZGUpOwogCXN0cnVjdCBjZXBoX2ZzX2NsaWVudCAq
ZnNjID0gY2VwaF9pbm9kZV90b19jbGllbnQoaW5vZGUpOworCXN0cnVjdCBjZXBoX29zZF9jbGll
bnQgKm9zZGMgPSAmZnNjLT5jbGllbnQtPm9zZGM7CiAJc3RydWN0IGNlcGhfY2FwX2ZsdXNoICpw
cmVhbGxvY19jZjsKIAlzc2l6ZV90IGNvdW50LCB3cml0dGVuID0gMDsKIAlpbnQgZXJyLCB3YW50
LCBnb3Q7CiAJYm9vbCBkaXJlY3RfbG9jayA9IGZhbHNlOworCXUzMiBtYXBfZmxhZ3M7CisJdTY0
IHBvb2xfZmxhZ3M7CiAJbG9mZl90IHBvczsKIAlsb2ZmX3QgbGltaXQgPSBtYXgoaV9zaXplX3Jl
YWQoaW5vZGUpLCBmc2MtPm1heF9maWxlX3NpemUpOwogCkBAIC0xNzMwLDcgKzE3MzMsMTIgQEAg
c3RhdGljIHNzaXplX3QgY2VwaF93cml0ZV9pdGVyKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0
IGlvdl9pdGVyICpmcm9tKQogCX0KIAogCS8qIEZJWE1FOiBub3QgY29tcGxldGUgc2luY2UgaXQg
ZG9lc24ndCBhY2NvdW50IGZvciBiZWluZyBhdCBxdW90YSAqLwotCWlmIChjZXBoX29zZG1hcF9m
bGFnKCZmc2MtPmNsaWVudC0+b3NkYywgQ0VQSF9PU0RNQVBfRlVMTCkpIHsKKwlkb3duX3JlYWQo
Jm9zZGMtPmxvY2spOworCW1hcF9mbGFncyA9IG9zZGMtPm9zZG1hcC0+ZmxhZ3M7CisJcG9vbF9m
bGFncyA9IGNlcGhfcGdfcG9vbF9mbGFncyhvc2RjLT5vc2RtYXAsIGNpLT5pX2xheW91dC5wb29s
X2lkKTsKKwl1cF9yZWFkKCZvc2RjLT5sb2NrKTsKKwlpZiAoKG1hcF9mbGFncyAmIENFUEhfT1NE
TUFQX0ZVTEwpIHx8CisJICAgIChwb29sX2ZsYWdzICYgQ0VQSF9QT09MX0ZMQUdfRlVMTCkpIHsK
IAkJZXJyID0gLUVOT1NQQzsKIAkJZ290byBvdXQ7CiAJfQpAQCAtMTgyMyw3ICsxODMxLDggQEAg
c3RhdGljIHNzaXplX3QgY2VwaF93cml0ZV9pdGVyKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0
IGlvdl9pdGVyICpmcm9tKQogCX0KIAogCWlmICh3cml0dGVuID49IDApIHsKLQkJaWYgKGNlcGhf
b3NkbWFwX2ZsYWcoJmZzYy0+Y2xpZW50LT5vc2RjLCBDRVBIX09TRE1BUF9ORUFSRlVMTCkpCisJ
CWlmICgobWFwX2ZsYWdzICYgQ0VQSF9PU0RNQVBfTkVBUkZVTEwpIHx8CisJCSAgICAocG9vbF9m
bGFncyAmIENFUEhfUE9PTF9GTEFHX05FQVJGVUxMKSkKIAkJCWlvY2ItPmtpX2ZsYWdzIHw9IElP
Q0JfRFNZTkM7CiAJCXdyaXR0ZW4gPSBnZW5lcmljX3dyaXRlX3N5bmMoaW9jYiwgd3JpdHRlbik7
CiAJfQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9jZXBoL29zZG1hcC5oIGIvaW5jbHVkZS9s
aW51eC9jZXBoL29zZG1hcC5oCmluZGV4IGUwODFiNTZmMWMxZC4uNjUxZTFiOTY3NjA4IDEwMDY0
NAotLS0gYS9pbmNsdWRlL2xpbnV4L2NlcGgvb3NkbWFwLmgKKysrIGIvaW5jbHVkZS9saW51eC9j
ZXBoL29zZG1hcC5oCkBAIC0zNyw2ICszNyw3IEBAIGludCBjZXBoX3NwZ19jb21wYXJlKGNvbnN0
IHN0cnVjdCBjZXBoX3NwZyAqbGhzLCBjb25zdCBzdHJ1Y3QgY2VwaF9zcGcgKnJocyk7CiAjZGVm
aW5lIENFUEhfUE9PTF9GTEFHX0hBU0hQU1BPT0wJKDFVTEwgPDwgMCkgLyogaGFzaCBwZyBzZWVk
IGFuZCBwb29sIGlkCiAJCQkJCQkgICAgICAgdG9nZXRoZXIgKi8KICNkZWZpbmUgQ0VQSF9QT09M
X0ZMQUdfRlVMTAkJKDFVTEwgPDwgMSkgLyogcG9vbCBpcyBmdWxsICovCisjZGVmaW5lIENFUEhf
UE9PTF9GTEFHX05FQVJGVUxMCQkoMVVMTCA8PCAxMSkgLyogcG9vbCBpcyBuZWFyZnVsbCAqLwog
CiBzdHJ1Y3QgY2VwaF9wZ19wb29sX2luZm8gewogCXN0cnVjdCByYl9ub2RlIG5vZGU7CkBAIC0z
MDQsNSArMzA1LDYgQEAgZXh0ZXJuIHN0cnVjdCBjZXBoX3BnX3Bvb2xfaW5mbyAqY2VwaF9wZ19w
b29sX2J5X2lkKHN0cnVjdCBjZXBoX29zZG1hcCAqbWFwLAogCiBleHRlcm4gY29uc3QgY2hhciAq
Y2VwaF9wZ19wb29sX25hbWVfYnlfaWQoc3RydWN0IGNlcGhfb3NkbWFwICptYXAsIHU2NCBpZCk7
CiBleHRlcm4gaW50IGNlcGhfcGdfcG9vbGlkX2J5X25hbWUoc3RydWN0IGNlcGhfb3NkbWFwICpt
YXAsIGNvbnN0IGNoYXIgKm5hbWUpOwordTY0IGNlcGhfcGdfcG9vbF9mbGFncyhzdHJ1Y3QgY2Vw
aF9vc2RtYXAgKm1hcCwgdTY0IGlkKTsKIAogI2VuZGlmCmRpZmYgLS1naXQgYS9uZXQvY2VwaC9v
c2RtYXAuYyBiL25ldC9jZXBoL29zZG1hcC5jCmluZGV4IDRlMGRlMTRmODBiYi4uMmE2ZTYzYThl
ZGJlIDEwMDY0NAotLS0gYS9uZXQvY2VwaC9vc2RtYXAuYworKysgYi9uZXQvY2VwaC9vc2RtYXAu
YwpAQCAtNzEwLDYgKzcxMCwxNSBAQCBpbnQgY2VwaF9wZ19wb29saWRfYnlfbmFtZShzdHJ1Y3Qg
Y2VwaF9vc2RtYXAgKm1hcCwgY29uc3QgY2hhciAqbmFtZSkKIH0KIEVYUE9SVF9TWU1CT0woY2Vw
aF9wZ19wb29saWRfYnlfbmFtZSk7CiAKK3U2NCBjZXBoX3BnX3Bvb2xfZmxhZ3Moc3RydWN0IGNl
cGhfb3NkbWFwICptYXAsIHU2NCBpZCkKK3sKKwlzdHJ1Y3QgY2VwaF9wZ19wb29sX2luZm8gKnBp
OworCisJcGkgPSBfX2xvb2t1cF9wZ19wb29sKCZtYXAtPnBnX3Bvb2xzLCBpZCk7CisJcmV0dXJu
IHBpID8gcGktPmZsYWdzIDogMDsKK30KK0VYUE9SVF9TWU1CT0woY2VwaF9wZ19wb29sX2ZsYWdz
KTsKKwogc3RhdGljIHZvaWQgX19yZW1vdmVfcGdfcG9vbChzdHJ1Y3QgcmJfcm9vdCAqcm9vdCwg
c3RydWN0IGNlcGhfcGdfcG9vbF9pbmZvICpwaSkKIHsKIAlyYl9lcmFzZSgmcGktPm5vZGUsIHJv
b3QpOwo=
--000000000000adc5df05a0720e7d--
