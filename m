Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34E045628B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhKRSlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbhKRSlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:41:16 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7E4C061574;
        Thu, 18 Nov 2021 10:38:15 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id e136so20814166ybc.4;
        Thu, 18 Nov 2021 10:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ixhgm2s62Z4HwBsJ6qusKDYK8qBy46in4O+L2y7KtNk=;
        b=JaRLKHOq9U1Snip6gy1N+HmsjBmI/9fE7jXPhzzuB0tC9UIOhbvSDt8O++xOXldF2E
         +9dWbZzgD2GfgvLui/XTku3n9FvFi8KdeRwoRtNfANOMWjH03JjAOB0a6G0QNh7cjyNM
         Jr+4285L5OnKTXPpL6MQYX4pULEUQ8JmCksJHBpL6M7U9Jkm2If4RjnuezRVp9Pjkl1x
         3uA1ozFJt7x0XjmLV0Y4hYTPU+aqDRauETP1aK7SRQ7PhHrCmEZYsRW3N8zRv8/DowrA
         ygIrierHvcpU2eWHbYLeIoUHaAN/Dpn2XVLdXjtnyYfWJVrKpDOsTeMuepVN6M1ysBJX
         aqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ixhgm2s62Z4HwBsJ6qusKDYK8qBy46in4O+L2y7KtNk=;
        b=W7hXdnydlTETz8JYDMIAGnskPPAOAvP2CnhcjjHi4y1A7EW2k2Y/X4hsgthfdJQ25F
         gBWO7jq/g+pzygbrkvKDVKsKfMHWJ/uE83PAm5VV/RHvvLz+WBhZqSLqSlO3e4xTRDsr
         SPyqLIWhwWP9CnoYw+UqbIGuB9BnRfQr7/1T5zbgYBSCkUebgHIz506FC83SFU5sFhyC
         AI3vxka13zUmLxHet8WA+2btrbvxDMWNQpE8F3qSHLcroFQp90dgopoXhrk0T3Fmu8/S
         z7MScEx545r38g6V2So9TANreX1Tr6m8mOl5AyEyJxX1UnfQS+8DQ4LdALUTFZQByLZw
         7CIQ==
X-Gm-Message-State: AOAM5320wfE7ZLFT1aZNPH0DPVx9mMSDXb9OKxaFw4ogv0mtmFLme7gW
        bH9VQUdadhxFlExMtB+79bp6zx/Us4Ba38rAoYs=
X-Google-Smtp-Source: ABdhPJwB7AZ6vxnEjgf4p0dk+bgJ5nPC5fRM/Lvy4Ukx0HdlBXPGYwhmU/limhcAFZcIZWa8b2O4tMB7E6lOgJQWQYM=
X-Received: by 2002:a05:6902:1023:: with SMTP id x3mr29269555ybt.267.1637260695081;
 Thu, 18 Nov 2021 10:38:15 -0800 (PST)
MIME-Version: 1.0
References: <20211118115225.1349726-1-iii@linux.ibm.com>
In-Reply-To: <20211118115225.1349726-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Nov 2021 10:38:04 -0800
Message-ID: <CAEf4BzajYRJfqwB7oYwWX_-K8WzMdiOTbZiW3zqKm+oYjEu2PA@mail.gmail.com>
Subject: Re: [PATCH bpf] selfetests/bpf: Adapt vmtest.sh to s390 libbpf CI changes
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shuah Khan <shuah@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 3:52 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
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

Thanks for the quick fix! I did rm -r ~/.bpf_selftest (though I
thought I did that with my changes as well, whatever) before running
vmtest.sh. It all worked. I got three test failures which is strange,
because I don't get those failures in my custom and more complete QEMU
image, so it's strange, if anyone has any ideas and is willing to help
debug this, it would be greatly appreciated.

But either way, this fixes immediate problems with vmtest.sh, pushed
to bpf-next. Thanks!


All error logs:

#17 btf_map_in_map:FAIL
test_lookup_update:PASS:skel_open 0 nsec
test_lookup_update:PASS:skel_attach 0 nsec
test_lookup_update:PASS:inner1 0 nsec
test_lookup_update:PASS:inner2 0 nsec
test_lookup_update:PASS:inner3 0 nsec
test_lookup_update:PASS:inner1 0 nsec
test_lookup_update:PASS:inner2 0 nsec
test_lookup_update:PASS:inner4 0 nsec
test_lookup_update:PASS:inner5 0 nsec
test_lookup_update:PASS:map1_id 0 nsec
test_lookup_update:PASS:map2_id 0 nsec
test_lookup_update:PASS:sync_rcu 0 nsec
test_lookup_update:PASS:sync_rcu 0 nsec
test_lookup_update:FAIL:map1_leak inner_map1 leaked!
#17/1 btf_map_in_map/lookup_update:FAIL
test_diff_size:PASS:skel_open 0 nsec
test_diff_size:PASS:outer_sockarr inner map size check 0 nsec
test_diff_size:PASS:outer_arr inner map size check 0 nsec
#17/2 btf_map_in_map/diff_size:OK

#147 task_local_storage:FAIL
test_sys_enter_exit:PASS:skel_open_and_load 0 nsec
test_sys_enter_exit:PASS:skel_attach 0 nsec
test_sys_enter_exit:PASS:enter_cnt 0 nsec
test_sys_enter_exit:PASS:exit_cnt 0 nsec
test_sys_enter_exit:PASS:mismatch_cnt 0 nsec
#147/1 task_local_storage/sys_enter_exit:OK
test_exit_creds:PASS:skel_open_and_load 0 nsec
test_exit_creds:PASS:skel_attach 0 nsec
test_exit_creds:PASS:valid_ptr_count 0 nsec
test_exit_creds:FAIL:null_ptr_count unexpected null_ptr_count: actual
0 == expected 0
#147/2 task_local_storage/exit_creds:FAIL
test_recursion:PASS:skel_open_and_load 0 nsec
test_recursion:PASS:skel_attach 0 nsec
#147/3 task_local_storage/recursion:OK

#155 test_bpffs:FAIL
test_test_bpffs:PASS:clone 0 nsec
test_test_bpffs:PASS:waitpid 0 nsec
test_test_bpffs:FAIL:bpffs test  failed 255
Summary: 209/967 PASSED, 10 SKIPPED, 3 FAILED


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
