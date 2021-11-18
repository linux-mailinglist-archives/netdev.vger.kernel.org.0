Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B265B4562C6
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhKRSrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhKRSrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:47:48 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39297C061574;
        Thu, 18 Nov 2021 10:44:48 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id u3so30633362lfl.2;
        Thu, 18 Nov 2021 10:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KtBf3b/XHtk1bqoyzceQSEj+SyTHp41FF2tWEqfwnLw=;
        b=buQn+iZM9hwMl0Gk9RdXKnnAf/E/uLVBWm7VBqTqhi6RS/ynPzXTQocvXe4q6gFupy
         c1pu5ohqU2BD9dJasj+QURvXwsKgJUTRk45Hk31gQhqPNT+Z5y1EPSUde+St2VwwT7DK
         h0M+lZXL54d1V7OG3GhMY7VfO+GZV48SI28SPDBZVNmJyhGRCr172x+yxpuHa0zd3kxe
         YGf3IX+0COPwKMXGdsjOsCBXHh20eMpiV8nNopR80lIi3M45oNhmx2qx+LVb2E+ufEAW
         CZosKf2jSR6o134g1UsmOjhVuuub0efyJLxLewm7hItoTrEtskEuPQWzb0y+5htrMR9P
         EslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KtBf3b/XHtk1bqoyzceQSEj+SyTHp41FF2tWEqfwnLw=;
        b=V1KgUhQzZ9V/6k6F9rfvlcSC1OaZgpigDC199kaBsU5y0AJigfSfI/xa05CoCOQvMJ
         m9MmENEkTLucF3cXbsQW4+vdDfXsvQnqQ1SRXcvwiArLwbe/3IxiK+IW9VHFBwDeznHF
         Zbpe5LWnndYddmiWlyMIgxlzK/LqPDXwXcmLnKZrZuJLMJRpEn0piaDSWxJxc3I1H7i2
         NYsTNT7rGdHuFrhvKIq7ST4mQVsqzwuGV91uZybQibM8qkXMnzWKiUuEcGUoEjRcwo6h
         OAVmm8R+O6fWWYxKi0ZfgneUoc0Ye3upqIvb/TktpM8K1as/zEbX1TbytyUvsUTwa/y7
         ucRQ==
X-Gm-Message-State: AOAM531CJ42drX5FFdLXYw2p5sFhVWnm+LCY4u3hrQNdRHOffTPpI3kY
        dyJ4k3q82jq5BvOGVHtmJsknurNqY07nDCj1U00=
X-Google-Smtp-Source: ABdhPJwdjFq/6ndUGke0X96RAeuKW7QfP7GtmnYgdBZsHbyy+1ZplNrF1S0qIjKJ9TF2gDhwfHbMDv7GptCo0knLVAQ=
X-Received: by 2002:a2e:a451:: with SMTP id v17mr19299608ljn.85.1637261086361;
 Thu, 18 Nov 2021 10:44:46 -0800 (PST)
MIME-Version: 1.0
References: <20211118115225.1349726-1-iii@linux.ibm.com>
In-Reply-To: <20211118115225.1349726-1-iii@linux.ibm.com>
From:   "sunyucong@gmail.com" <sunyucong@gmail.com>
Date:   Thu, 18 Nov 2021 10:44:20 -0800
Message-ID: <CAJygYd31WmTyhKkMNiP0gOJv7XA3PYXp_+Fqxi6Pd6K1004cbg@mail.gmail.com>
Subject: Re: [PATCH bpf] selfetests/bpf: Adapt vmtest.sh to s390 libbpf CI changes
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shuah Khan <shuah@kernel.org>, kernel-team@cloudflare.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 3:54 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> [1] added s390 support to libbpf CI and added an ${ARCH} prefix to a
> number of paths and identifiers in libbpf GitHub repo, which vmtest.sh
> relies upon. Update these and make use of the new s390 support.
>
> [1] https://github.com/libbpf/libbpf/pull/204
>
> Co-developed-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  tools/testing/selftests/bpf/vmtest.sh | 46 ++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
> index 027198768fad..5e43c79ddc6e 100755
> --- a/tools/testing/selftests/bpf/vmtest.sh
> +++ b/tools/testing/selftests/bpf/vmtest.sh
> @@ -4,17 +4,34 @@
>  set -u
>  set -e
>
> -# This script currently only works for x86_64, as
> -# it is based on the VM image used by the BPF CI which is
> -# x86_64.
> -QEMU_BINARY="${QEMU_BINARY:="qemu-system-x86_64"}"
> -X86_BZIMAGE="arch/x86/boot/bzImage"
> +# This script currently only works for x86_64 and s390x, as
> +# it is based on the VM image used by the BPF CI, which is
> +# available only for these architectures.
> +ARCH="$(uname -m)"
> +case "${ARCH}" in
> +s390x)
> +       QEMU_BINARY=qemu-system-s390x
> +       QEMU_CONSOLE="ttyS1"
> +       QEMU_FLAGS=(-smp 2)
> +       BZIMAGE="arch/s390/boot/compressed/vmlinux"
> +       ;;
> +x86_64)
> +       QEMU_BINARY=qemu-system-x86_64
> +       QEMU_CONSOLE="ttyS0,115200"
> +       QEMU_FLAGS=(-cpu host -smp 8)
> +       BZIMAGE="arch/x86/boot/bzImage"
> +       ;;
> +*)
> +       echo "Unsupported architecture"
> +       exit 1
> +       ;;
> +esac
>  DEFAULT_COMMAND="./test_progs"
>  MOUNT_DIR="mnt"
>  ROOTFS_IMAGE="root.img"
>  OUTPUT_DIR="$HOME/.bpf_selftests"
> -KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/latest.config"
> -KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/latest.config"
> +KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/config-latest.${ARCH}"
> +KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/config-latest.${ARCH}"
>  INDEX_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/INDEX"
>  NUM_COMPILE_JOBS="$(nproc)"
>  LOG_FILE_BASE="$(date +"bpf_selftests.%Y-%m-%d_%H-%M-%S")"
> @@ -85,7 +102,7 @@ newest_rootfs_version()
>  {
>         {
>         for file in "${!URLS[@]}"; do
> -               if [[ $file =~ ^libbpf-vmtest-rootfs-(.*)\.tar\.zst$ ]]; then
> +               if [[ $file =~ ^"${ARCH}"/libbpf-vmtest-rootfs-(.*)\.tar\.zst$ ]]; then
>                         echo "${BASH_REMATCH[1]}"
>                 fi
>         done
> @@ -102,7 +119,7 @@ download_rootfs()
>                 exit 1
>         fi
>
> -       download "libbpf-vmtest-rootfs-$rootfsversion.tar.zst" |
> +       download "${ARCH}/libbpf-vmtest-rootfs-$rootfsversion.tar.zst" |
>                 zstd -d | sudo tar -C "$dir" -x
>  }
>
> @@ -224,13 +241,12 @@ EOF
>                 -nodefaults \
>                 -display none \
>                 -serial mon:stdio \
> -               -cpu host \
> +               "${qemu_flags[@]}" \
>                 -enable-kvm \
> -               -smp 8 \
>                 -m 4G \
>                 -drive file="${rootfs_img}",format=raw,index=1,media=disk,if=virtio,cache=none \
>                 -kernel "${kernel_bzimage}" \
> -               -append "root=/dev/vda rw console=ttyS0,115200"
> +               -append "root=/dev/vda rw console=${QEMU_CONSOLE}"
>  }
>
>  copy_logs()
> @@ -282,7 +298,7 @@ main()
>         local kernel_checkout=$(realpath "${script_dir}"/../../../../)
>         # By default the script searches for the kernel in the checkout directory but
>         # it also obeys environment variables O= and KBUILD_OUTPUT=
> -       local kernel_bzimage="${kernel_checkout}/${X86_BZIMAGE}"
> +       local kernel_bzimage="${kernel_checkout}/${BZIMAGE}"
>         local command="${DEFAULT_COMMAND}"
>         local update_image="no"
>         local exit_command="poweroff -f"
> @@ -337,13 +353,13 @@ main()
>                 if is_rel_path "${O}"; then
>                         O="$(realpath "${PWD}/${O}")"
>                 fi
> -               kernel_bzimage="${O}/${X86_BZIMAGE}"
> +               kernel_bzimage="${O}/${BZIMAGE}"
>                 make_command="${make_command} O=${O}"
>         elif [[ "${KBUILD_OUTPUT:=""}" != "" ]]; then
>                 if is_rel_path "${KBUILD_OUTPUT}"; then
>                         KBUILD_OUTPUT="$(realpath "${PWD}/${KBUILD_OUTPUT}")"
>                 fi
> -               kernel_bzimage="${KBUILD_OUTPUT}/${X86_BZIMAGE}"
> +               kernel_bzimage="${KBUILD_OUTPUT}/${BZIMAGE}"
>                 make_command="${make_command} KBUILD_OUTPUT=${KBUILD_OUTPUT}"
>         fi
>
> --
> 2.31.1
>

Acked-By: Yucong Sun <sunyucong@gmail.com>
