Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D381274123
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfGXV6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:58:48 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40590 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfGXV6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:58:47 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so47075845qtn.7;
        Wed, 24 Jul 2019 14:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mCThPvcBpP7M+g9ed13rTpPQ+RSsjtoRAfpVwpH3rKM=;
        b=kuoPyuzOKYCJkV7OX1WnPx4hMuw85/sMkaaB0gBObVD+CKDw2QXfyFG+Je6euRUFX/
         /l8BwykbRZ7puKz3DX3zPM14noae5Mik6IO8bh3dxLVyIXw/X5F9rz0lC1AWmaJ6j1d1
         NbYpmSOqz5LaJUo02aETfodEhQq74DmaA+gBTDYmVNqDb/xSE2F/pW7SORqy/y6Auxjl
         YE6n54M9GGP46oujiYL1DKXsEAmhyEmBRKPT+OGbCP+VKMCbtPjlpIKo7YmxgMpFIh8F
         fLGRHiSHLUQN+INlQOTMdekeDxEl65R/3XCDfAaSMj9Cm+OG1RXjT5MbeNWBWajoH8KC
         yFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mCThPvcBpP7M+g9ed13rTpPQ+RSsjtoRAfpVwpH3rKM=;
        b=rgjBCGMUaaftT4Lrx2m3keAuV0mXPVI76JEhIprylNanieTm9eTcoeKYIzVCgnGLkU
         bgzlWNwd4ih7dwR8ndgD7hDR7pwarMfSxHXluMst6cwWRUHmVhmyEDhXB/L0vTEIkhWd
         ZrStnZAgw/gc5w93+YdgwqRTBlDDz6I+rnhtcyiHfA1EPSwAeQB2Na/yceuPqAIqRoM+
         fNKGuLXlJzDA+JRTmNFF1nI8go05L759jyDX5pUokUVWvfXIBCr0LrZnfTmPLKXMIVYf
         VgTp+rrv9Y5Vo/4GXm03mvleBwSHADpLEZfY03oTUDzCaeFIan3mG0AVI+4vifuEdn6X
         18TA==
X-Gm-Message-State: APjAAAWIyRERFKnQtq8jKyC96psH+Jd/VHz2VeWJq3dKWC0JPXdec4ci
        Y2BJ+CPyF1e9pxWk/YZc4z9ENY/AN3RoRo2+KWA=
X-Google-Smtp-Source: APXvYqypG1ViXV4qx6YKCuebe2O7t6Z4y1aSzIj/bR3ypCb1uJi/d9AI6423nkoaO/+Hsqn+DuDp27tenw0v58TMvfk=
X-Received: by 2002:ac8:6a17:: with SMTP id t23mr57653342qtr.183.1564005526391;
 Wed, 24 Jul 2019 14:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-6-brianvv@google.com>
In-Reply-To: <20190724165803.87470-6-brianvv@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 14:58:34 -0700
Message-ID: <CAPhsuW7atDDF0PPu-L5VBarDQDiLtgGD99S=RUBApLuAQ9BXTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] selftests/bpf: test BPF_MAP_DUMP command on
 a bpf hashmap
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:10 AM Brian Vazquez <brianvv@google.com> wrote:
>
> This tests exercise the new command on a bpf hashmap and make sure it
> works as expected.
>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  tools/testing/selftests/bpf/test_maps.c | 83 ++++++++++++++++++++++++-
>  1 file changed, 81 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
> index 5443b9bd75ed7..f7ab401399d40 100644
> --- a/tools/testing/selftests/bpf/test_maps.c
> +++ b/tools/testing/selftests/bpf/test_maps.c
> @@ -309,6 +309,86 @@ static void test_hashmap_walk(unsigned int task, void *data)
>         close(fd);
>  }
>
> +static void test_hashmap_dump(void)
> +{
> +       int fd, i, max_entries = 5;

5 is too small for map_dump.

> +       uint64_t keys[max_entries], values[max_entries];
> +       uint64_t key, value, next_key, prev_key;
> +       bool next_key_valid = true;
> +       void *buf, *elem;
> +       u32 buf_len;
> +       const int elem_size = sizeof(key) + sizeof(value);
> +
> +       fd = helper_fill_hashmap(max_entries);
> +
> +       // Get the elements in the hashmap, and store them in that order

Please use /* */ instead of //.

> +       assert(bpf_map_get_next_key(fd, NULL, &key) == 0);
> +       i = 0;
> +       keys[i] = key;
> +       for (i = 1; next_key_valid; i++) {
> +               next_key_valid = bpf_map_get_next_key(fd, &key, &next_key) == 0;
> +               assert(bpf_map_lookup_elem(fd, &key, &values[i - 1]) == 0);
> +               keys[i-1] = key;
> +               key = next_key;
> +       }
> +
> +       // Alloc memory for the whole table
> +       buf = malloc(elem_size * max_entries);
> +       assert(buf != NULL);
> +
> +       // Check that buf_len < elem_size returns EINVAL
> +       buf_len = elem_size-1;
> +       errno = 0;
> +       assert(bpf_map_dump(fd, NULL, buf, &buf_len) == -1 && errno == EINVAL);
> +
> +       // Check that it returns the first two elements
> +       errno = 0;
> +       buf_len = elem_size * 2;
> +       i = 0;
> +       assert(bpf_map_dump(fd, NULL, buf, &buf_len) == 0 &&
> +              buf_len == 2*elem_size);
> +       elem = buf;
> +       assert((*(uint64_t *)elem) == keys[i] &&
> +              (*(uint64_t *)(elem + sizeof(key))) == values[i]);
> +       elem = buf + elem_size;
> +       i++;
> +       assert((*(uint64_t *)elem) == keys[i] &&
> +              (*(uint64_t *)(elem + sizeof(key))) == values[i]);
> +       i++;
> +
> +       /* Check that prev_key contains key from last_elem retrieved in previous
> +        * call
> +        */
> +       prev_key = *((uint64_t *)elem);
> +       assert(bpf_map_dump(fd, &prev_key, buf, &buf_len) == 0 &&
> +              buf_len == elem_size*2);
> +       elem = buf;
> +       assert((*(uint64_t *)elem) == keys[i] &&
> +              (*(uint64_t *)(elem + sizeof(key))) == values[i]);
> +       elem = buf + elem_size;
> +       i++;
> +       assert((*(uint64_t *)elem) == keys[i] &&
> +              (*(uint64_t *)(elem + sizeof(key))) == values[i]);
> +       i++;
> +       assert(prev_key == (*(uint64_t *)elem));
> +
> +       /* Continue reading from map and verify buf_len only contains 1 element
> +        * even though buf_len is 2 elem_size and it returns err = 0.
> +        */
> +       assert(bpf_map_dump(fd, &prev_key, buf, &buf_len) == 0 &&
> +              buf_len == elem_size);
> +       elem = buf;
> +       assert((*(uint64_t *)elem) == keys[i] &&
> +              (*(uint64_t *)(elem + sizeof(key))) == values[i]);
> +
> +       // Verify there's no more entries and err = ENOENT
> +       assert(bpf_map_dump(fd, &prev_key, buf, &buf_len) == -1 &&
> +              errno == ENOENT);
> +
> +       free(buf);
> +       close(fd);
> +}
> +
>  static void test_hashmap_zero_seed(void)
>  {
>         int i, first, second, old_flags;
> @@ -1677,6 +1757,7 @@ static void run_all_tests(void)
>         test_hashmap_percpu(0, NULL);
>         test_hashmap_walk(0, NULL);
>         test_hashmap_zero_seed();
> +       test_hashmap_dump();
>
>         test_arraymap(0, NULL);
>         test_arraymap_percpu(0, NULL);
> @@ -1714,11 +1795,9 @@ int main(void)
>
>         map_flags = BPF_F_NO_PREALLOC;
>         run_all_tests();
> -
>  #define CALL
>  #include <map_tests/tests.h>
>  #undef CALL
> -
>         printf("test_maps: OK, %d SKIPPED\n", skips);
>         return 0;
>  }
> --
> 2.22.0.657.g960e92d24f-goog
>
