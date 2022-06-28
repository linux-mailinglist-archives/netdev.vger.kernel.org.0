Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DF655EA36
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbiF1Qur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239619AbiF1QsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:48:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B862AC67
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:45:05 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 184so12699551pga.12
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SgJi6HSRfulEjVLhuwzr6sRMTQYrmglBqBwGYR1LzqU=;
        b=A6SnXln0ApqsIbpcBxBpUewKg4JGRH8vBhO4xil4qje8ns4FG1slYB2U7lXl/DZV9U
         so/8dz7QHgQFjihT79tJWUX6bdG/V9H7aK/FjFmDpkUHeoMVmqHgpD4Yl5wNluJyo1ia
         mfFKCW/vrwAJmUrLLZX3PmLcH8ArO2T2UerwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SgJi6HSRfulEjVLhuwzr6sRMTQYrmglBqBwGYR1LzqU=;
        b=ekArz2/9L4GN7ZUSaVxHNr3aph3Uuqt27v/tQnNz3bnrAgYJPM3SAHczFyuocQfIJ0
         Fk5mgpJ9Sjg12eML1XIIZc/uuLNHje2EJPfY7lk6XlSW4ukW9K14NWY9GS/UKvLfBW2u
         hY/TP/0SV0vGPD1PJF2raHzDnJz2G+z1gENDNrJqChrZIml55LANLqDAycpzGTN4LEan
         ZJshScDXKPm5pxuQ1lry8odjCa1prqYd2bnWdFki+Kd87D5rusUStxCqJ92sw9PadLd+
         y9FVfRZZ32i5ZuGWa23Yc97+GPPDWHXHZgS8oY5eTBWvDV7WCQ2v48TlCUiPY+ruSAbc
         vp5g==
X-Gm-Message-State: AJIora9f9aqCaj1lLxigZk3d9fxYpozX9ASiCVAgTVExPnJGdJ6MSa4Z
        8mCmIZuUZdSQDMKbc396v+icbQ==
X-Google-Smtp-Source: AGRyM1sHBmQkr6yDLMWd/GA+NEBcITdCLLgd2hkYzJHTQpIfX1nR3rvAbs3uYK/aJNFPEm3sOzVmEg==
X-Received: by 2002:a63:4d5:0:b0:40d:77fd:cff8 with SMTP id 204-20020a6304d5000000b0040d77fdcff8mr18204748pge.361.1656434704611;
        Tue, 28 Jun 2022 09:45:04 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id cb14-20020a056a00430e00b0051bbe085f16sm9630866pfb.104.2022.06.28.09.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:45:03 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, dsahern@kernel.org, stephen@networkplumber.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH iproute2-next v1 2/2] devlink: add support for running selftests
Date:   Tue, 28 Jun 2022 22:14:47 +0530
Message-Id: <20220628164447.45202-3-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220628164447.45202-1-vikas.gupta@broadcom.com>
References: <20220628164447.45202-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003383c205e284c267"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003383c205e284c267

Add command and helper APIs to run selfests.
Also add a seltest for flash on the device.

Examples:
$ devlink dev selftests run pci/0000:03:00.0 test flash
 results:
    flash test :  failed

$ devlink dev selftests show pci/0000:03:00.0
device suuports:
    flash test

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 devlink/devlink.c | 157 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ddf430bb..2f7c4ff9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -294,6 +294,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(49)
 #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
 #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
+#define DL_OPT_SELFTESTS		BIT(52)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -344,6 +345,7 @@ struct dl_opts {
 	uint32_t overwrite_mask;
 	enum devlink_reload_action reload_action;
 	enum devlink_reload_limit reload_limit;
+	uint32_t selftests_mask;
 	uint32_t port_controller;
 	uint32_t port_sfnumber;
 	uint16_t port_flavour;
@@ -1401,6 +1403,19 @@ static struct str_num_map port_fn_opstate_map[] = {
 	{ .str = NULL, }
 };
 
+static int selftests_get(const char *testname, uint32_t *mask)
+{
+	if (strcmp(testname, "flash") == 0) {
+		*mask |= DEVLINK_SELFTEST_FLASH;
+	} else if (strcmp(testname, "all") == 0) {
+		*mask = DEVLINK_SUPPORTED_SELFTESTS;
+	} else {
+		pr_err("Unknown selftest \"%s\"\n", testname);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int port_flavour_parse(const char *flavour, uint16_t *value)
 {
 	int num;
@@ -1490,6 +1505,7 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expected."},
 	{DL_OPT_PORT_FLAVOUR,          "Port flavour is expected."},
 	{DL_OPT_PORT_PFNUMBER,         "Port PCI PF number is expected."},
+	{DL_OPT_SELFTESTS,             "Test name is expected"},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1793,6 +1809,20 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 				return err;
 			o_found |= DL_OPT_FLASH_OVERWRITE;
 
+		} else if (dl_argv_match(dl, "test") &&
+				(o_all & DL_OPT_SELFTESTS)) {
+			const char *testname;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &testname);
+			if( err)
+				return err;
+			err = selftests_get(testname,
+					    &opts->selftests_mask);
+			if (err)
+				return err;
+			o_found |= DL_OPT_SELFTESTS;
+
 		} else if (dl_argv_match(dl, "reporter") &&
 			   (o_all & DL_OPT_HEALTH_REPORTER_NAME)) {
 			dl_arg_inc(dl);
@@ -2063,6 +2093,17 @@ dl_reload_limits_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
 	mnl_attr_put(nlh, DEVLINK_ATTR_RELOAD_LIMITS, sizeof(limits), &limits);
 }
 
+static void
+dl_selftests_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
+{
+	struct nla_bitfield32 selftests_mask;
+	selftests_mask.selector = DEVLINK_SUPPORTED_SELFTESTS;
+	selftests_mask.value = opts->selftests_mask;
+
+	mnl_attr_put(nlh, DEVLINK_ATTR_SELFTESTS_MASK,
+		     sizeof(selftests_mask), &selftests_mask);
+}
+
 static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 {
 	struct dl_opts *opts = &dl->opts;
@@ -2157,6 +2198,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				  opts->flash_component);
 	if (opts->present & DL_OPT_FLASH_OVERWRITE)
 		dl_flash_update_overwrite_put(nlh, opts);
+	if (opts->present & DL_OPT_SELFTESTS)
+		dl_selftests_put(nlh, opts);
 	if (opts->present & DL_OPT_HEALTH_REPORTER_NAME)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
 				  opts->reporter_name);
@@ -2285,6 +2328,8 @@ static void cmd_dev_help(void)
 	pr_err("                              [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
 	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
+	pr_err("       devlink dev selftests show DEV\n");
+	pr_err("       devlink dev selftests run DEV test {flash | all}\n");
 }
 
 static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
@@ -3904,6 +3949,115 @@ err_socket:
 	return err;
 }
 
+static int cmd_dev_selftests_show_tests(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct nlattr *test_name_attr;
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_TEST_NAMES])  {
+		return MNL_CB_ERROR;
+	}
+
+	pr_out_array_start(dl, "device supports");
+
+	mnl_attr_for_each_nested(test_name_attr, tb[DEVLINK_ATTR_TEST_NAMES]) {
+		pr_out_entry_start(dl);
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, NULL, "%s",
+			     mnl_attr_get_str(test_name_attr));
+		pr_out_entry_end(dl);
+	}
+
+	pr_out_array_end(dl);
+	return 0;
+}
+
+static int cmd_dev_selftests_result_show(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *test_res[DEVLINK_ATTR_MAX + 1] = {};
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct nlattr *nla_header;
+	struct dl *dl = data;
+	int err = 0;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_TEST_RESULTS])  {
+		return MNL_CB_ERROR;
+	}
+
+	pr_out_array_start(dl, "results");
+
+	mnl_attr_for_each_nested(nla_header, tb[DEVLINK_ATTR_TEST_RESULTS]) {
+		err = mnl_attr_parse_nested(nla_header, attr_cb, test_res);
+		if (err != MNL_CB_OK)
+			goto err_result_show;
+		pr_out_entry_start(dl);
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, NULL, "%s : ",
+			     mnl_attr_get_str(test_res[DEVLINK_ATTR_TEST_NAME]));
+		print_string(PRINT_ANY, NULL, " %s",
+			     mnl_attr_get_u8(test_res[DEVLINK_ATTR_TEST_RESULT_VAL]) ? "passed" : "failed");
+		pr_out_entry_end(dl);
+	}
+
+err_result_show:
+	pr_out_array_end(dl);
+	return err;
+}
+
+static int cmd_dev_selftests_run(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	int err;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_RUN, flags);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_SELFTESTS, 0);
+	if (err)
+		return err;
+
+	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_selftests_result_show, dl);
+	return err;
+}
+
+static int cmd_dev_selftests_show(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_SHOW, flags);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
+	if (err)
+		return err;
+
+	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_selftests_show_tests, dl);
+	return err;
+}
+
+static int cmd_dev_selftests(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_dev_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_dev_selftests_show(dl);
+	} else if (dl_argv_match(dl, "run")) {
+		dl_arg_inc(dl);
+		return cmd_dev_selftests_run(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_dev(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -3928,6 +4082,9 @@ static int cmd_dev(struct dl *dl)
 	} else if (dl_argv_match(dl, "flash")) {
 		dl_arg_inc(dl);
 		return cmd_dev_flash(dl);
+	} else if (dl_argv_match(dl, "selftests")) {
+		dl_arg_inc(dl);
+		return cmd_dev_selftests(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
-- 
2.31.1


--0000000000003383c205e284c267
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
I7qKxvF8Yo7eGTnHRTa99J+6yTd88AKVuhM5TEhpC8cS7qvrQXJje+Uing2xWC4FH76LEWIFH0Pt
x8C1WoCU0ClXHU/XfzH2mYrFANBSCeP1Co6QdEfRAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUc6J11rH3s6PyZQ0zIVZHIuP20Yw
DQYJKoZIhvcNAQELBQADggEBALvCjXn9gy9a2nU/Ey0nphGZefIP33ggiyuKnmqwBt7Wk/uDHIIc
kkIlqtTbo0x0PqphS9A23CxCDjKqZq2WN34fL5MMW83nrK0vqnPloCaxy9/6yuLbottBY4STNuvA
mQ//Whh+PE+DZadqiDbxXbos3IH8AeFXH4A1zIqIrc0Um2/CSD/T6pvu9QrchtvemfP0z/f1Bk+8
QbQ4ARVP93WV1I13US69evWXw+mOv9VnejShU9PMcDK203xjXbBOi9Hm+fthrWfwIyGoC5aEf7vd
PKkEDt4VZ9RbudZU/c3N8+kURaHNtrvu2K+mQs5w/AF7HYZThqmOzQJnvMRjuL8xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwYjepatB64S625eswwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICUeY+G1CpRy/kEfhbRK4LEV+g8X7W1rFQdV
fY6bEwb3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDYyODE2
NDUwNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQBkLaYT2Wr1DPb8uF28nNk6Z4tvAY6c6hEWtwt9OZOqStvm2uC4ITE9
xae3B6FRjW7FXicmzWNZDt8mviDLIXNb7GsidrCzZaN5vSlfqH8jIGOxUbB+ob9XA4A4vs5FYm+y
QKf9bfW4K16t4tLbySULGrGxh6xZsvck4RYccBv0GxgivuLL3LvwaRRb6b9eGc/IYnQUdAqMkROX
vgQ/QvFozdfrb1V3PxIdyJ7oDAoMgieMV3yHKW6APc2DkllSkEUVgHD+gYhvjcE0rffhLyW00KAn
OeDiiuLWeHtTTYbQeE9QU4l/V3jprJ0UDT3Je1fzLGXXy1/NXOhRNwBgMnQb
--0000000000003383c205e284c267--
