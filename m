Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF68577AE9
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 08:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiGRGXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 02:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbiGRGWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 02:22:47 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E3D15806
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 23:22:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x18-20020a17090a8a9200b001ef83b332f5so17292690pjn.0
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 23:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z184Hog2V4Dj+FGog+fbdSxloDOC76Od4rCb6nuY9cE=;
        b=DJKOP8hx09pS42/dX/1vd/mK5rFNyF8ua4mufEr3dlydwvwWZfdEMiYUcpAQTIWqbh
         FowFHBM5zyMAG/ByWMbOas2UOywqikz7kjUytBncOlq2n0NWIx9Pc0uIDrd2d+QJxSGi
         JXpotQIU4OnFEZOogJ28qP3SJJRL4SdTqanu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z184Hog2V4Dj+FGog+fbdSxloDOC76Od4rCb6nuY9cE=;
        b=vVEelIJZ16Qk6asciXuEsyip/wFs+KsKyAolQDXi5EhU0Og5O0BO+zrJByGfuI+0ML
         Y6Oj11pNMkV00zC5ou0OuSAoTRKQg562HYevLEj2bHL+Bxh0RIg2aea/147ovABU6HWz
         bjXG4RkIC4qg2armcr73udyGFuuS8Irp0WvL9aczOcmWNbr85rW3UyuiotucsDPRdRx8
         UiDh3aYdbggKZntxy0AbiKlz6W8Iw0mH3yaUipTdKeR5D/tt7ibITcuyNCQZY0E6wvU8
         upv6F4wBBDo0XT/3Fn31CfAlY6M4CS0H6ppgj5m78b7C3BVQlPWDp68dL9+cZwCPdFbI
         EpOQ==
X-Gm-Message-State: AJIora8xBbFAkM74gyU4JcyG7YEmSzVW519DYSm6NgTawVlF/MUJ0cNf
        dn7XX+UJiPVnJbRnWdEVVO1aGA==
X-Google-Smtp-Source: AGRyM1v4K0CTb7ahcoJd8aXrw8tCx8QZa4/1kMXGOUy+bVKjNa685JdJwBec+jQQQEH7p5+C0dFXpw==
X-Received: by 2002:a17:902:b78c:b0:16b:f943:ae98 with SMTP id e12-20020a170902b78c00b0016bf943ae98mr27019840pls.102.1658125365481;
        Sun, 17 Jul 2022 23:22:45 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i8-20020a17090a058800b001f1a192476csm3844307pji.15.2022.07.17.23.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 23:22:44 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, dsahern@kernel.org, stephen@networkplumber.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH iproute2-next v3 2/3] devlink: add support for running selftests
Date:   Mon, 18 Jul 2022 11:52:28 +0530
Message-Id: <20220718062229.22531-3-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220718062229.22531-1-vikas.gupta@broadcom.com>
References: <20220707183116.29422-1-vikas.gupta@broadcom.com>
 <20220718062229.22531-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006d8f8005e40e65a0"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000006d8f8005e40e65a0

Add command and helper APIs to run selfests.
Also add a seltest for flash on the device.

Examples:
$ devlink dev selftests run pci/0000:03:00.0 test flash
pci/0000:03:00.0
      flash failed

$ devlink dev selftests show pci/0000:03:00.0
pci/0000:03:00.0
      flash

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
---
 devlink/devlink.c | 292 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 292 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ddf430bb..36982332 100644
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
+	bool test_ids[DEVLINK_SELFTEST_ATTR_MAX + 1];
 	uint32_t port_controller;
 	uint32_t port_sfnumber;
 	uint16_t port_flavour;
@@ -693,6 +695,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_SELFTESTS_INFO] = MNL_TYPE_NESTED,
 };
 
 static const enum mnl_attr_data_type
@@ -1401,6 +1404,17 @@ static struct str_num_map port_fn_opstate_map[] = {
 	{ .str = NULL, }
 };
 
+static int selftests_get(const char *testname, bool *test_ids)
+{
+	if (strcmp(testname, "flash") == 0) {
+		test_ids[0] = 1;
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
@@ -1490,6 +1504,7 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expected."},
 	{DL_OPT_PORT_FLAVOUR,          "Port flavour is expected."},
 	{DL_OPT_PORT_PFNUMBER,         "Port PCI PF number is expected."},
+	{DL_OPT_SELFTESTS,             "Test name is expected"},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1793,6 +1808,20 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 				return err;
 			o_found |= DL_OPT_FLASH_OVERWRITE;
 
+		} else if (dl_argv_match(dl, "test") &&
+				(o_all & DL_OPT_SELFTESTS)) {
+			const char *testname;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &testname);
+			if (err)
+				return err;
+			err = selftests_get(testname,
+					    opts->test_ids);
+			if (err)
+				return err;
+			o_found |= DL_OPT_SELFTESTS;
+
 		} else if (dl_argv_match(dl, "reporter") &&
 			   (o_all & DL_OPT_HEALTH_REPORTER_NAME)) {
 			dl_arg_inc(dl);
@@ -2063,6 +2092,32 @@ dl_reload_limits_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
 	mnl_attr_put(nlh, DEVLINK_ATTR_RELOAD_LIMITS, sizeof(limits), &limits);
 }
 
+static void
+dl_selftests_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
+{
+	bool test_sel = false;
+	struct nlattr *nest;
+	int test_id;
+
+	nest = mnl_attr_nest_start(nlh, DEVLINK_ATTR_SELFTESTS_INFO);
+
+	for (test_id = 1; test_id < DEVLINK_SELFTEST_ATTR_MAX + 1 &&
+		opts->test_ids[test_id]; test_id++) {
+		if (opts->test_ids[test_id]) {
+			test_sel = true;
+			mnl_attr_put(nlh, test_id, 0, NULL);
+		}
+	}
+
+	/* No test selcted from user, select all */
+	if (!test_sel) {
+		for (test_id = 1; test_id < DEVLINK_SELFTEST_ATTR_MAX + 1; test_id++)
+			mnl_attr_put(nlh, test_id, 0, NULL);
+	}
+
+	mnl_attr_nest_end(nlh, nest);
+}
+
 static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 {
 	struct dl_opts *opts = &dl->opts;
@@ -2157,6 +2212,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				  opts->flash_component);
 	if (opts->present & DL_OPT_FLASH_OVERWRITE)
 		dl_flash_update_overwrite_put(nlh, opts);
+	if (opts->present & DL_OPT_SELFTESTS)
+		dl_selftests_put(nlh, opts);
 	if (opts->present & DL_OPT_HEALTH_REPORTER_NAME)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
 				  opts->reporter_name);
@@ -2285,6 +2342,8 @@ static void cmd_dev_help(void)
 	pr_err("                              [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
 	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
+	pr_err("       devlink dev selftests show [DEV]\n");
+	pr_err("       devlink dev selftests run DEV [test TESTNAME ]\n");
 }
 
 static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
@@ -3904,6 +3963,236 @@ err_socket:
 	return err;
 }
 
+static const char *devlink_get_selftests_name(int test_id)
+{
+	switch (test_id) {
+	case DEVLINK_SELFTEST_ATTR_FLASH:
+		return "flash";
+	default:
+		return "unknown";
+	}
+}
+
+static const enum mnl_attr_data_type
+devlink_selftests_list_policy[DEVLINK_SELFTEST_ATTR_MAX + 1] = {
+	[DEVLINK_SELFTEST_ATTR_FLASH] = MNL_TYPE_FLAG,
+};
+
+static int selftests_list_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type;
+
+	if (mnl_attr_type_valid(attr, DEVLINK_SELFTEST_ATTR_MAX) < 0)
+		return MNL_CB_OK;
+
+	type = mnl_attr_get_type(attr);
+	if (mnl_attr_validate(attr, devlink_selftests_list_policy[type]) < 0)
+		return MNL_CB_ERROR;
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int cmd_dev_selftests_show_tests(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *nla_value[DEVLINK_SELFTEST_ATTR_MAX + 1] = {};
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+	int avail = 0;
+	int err;
+	int i;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_SELFTESTS_INFO])
+		return MNL_CB_ERROR;
+
+	err = mnl_attr_parse_nested(tb[DEVLINK_ATTR_SELFTESTS_INFO],
+				    selftests_list_attr_cb, nla_value);
+	if (err != MNL_CB_OK)
+		return MNL_CB_ERROR;
+
+	for (i = 1; i < DEVLINK_SELFTEST_ATTR_MAX + 1; i++) {
+		if (!(nla_value[i]))
+			continue;
+
+		if (!avail) {
+			__pr_out_handle_start(dl, tb, true, false);
+			__pr_out_indent_inc();
+			if (!dl->json_output)
+				__pr_out_newline();
+			avail = 1;
+		}
+
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, NULL, "%s", devlink_get_selftests_name(i));
+		if (!dl->json_output)
+			__pr_out_newline();
+	}
+
+	if (avail) {
+		__pr_out_indent_dec();
+		pr_out_handle_end(dl);
+	}
+
+	return MNL_CB_OK;
+}
+
+static const char *selftest_result_to_str(uint8_t res)
+{
+	switch (res) {
+	case DEVLINK_SELFTEST_SKIP:
+		return "skipped";
+	case DEVLINK_SELFTEST_PASS:
+		return "passed";
+	case DEVLINK_SELFTEST_FAIL:
+		return "failed";
+	default:
+		return "unknown";
+	}
+}
+
+static const enum mnl_attr_data_type
+devlink_selftests_result_policy[DEVLINK_SELFTEST_ATTR_RES_MAX + 1] = {
+	[DEVLINK_SELFTEST_ATTR_RESULT] = MNL_TYPE_NESTED,
+	[DEVLINK_SELFTEST_ATTR_TEST_ID] = MNL_TYPE_U32,
+	[DEVLINK_SELFTEST_ATTR_TEST_STATUS] = MNL_TYPE_U8,
+};
+
+static int selftests_result_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type;
+
+	if (mnl_attr_type_valid(attr, DEVLINK_SELFTEST_ATTR_RES_MAX) < 0)
+		return MNL_CB_OK;
+
+	type = mnl_attr_get_type(attr);
+	if (mnl_attr_validate(attr, devlink_selftests_result_policy[type]) < 0)
+		return MNL_CB_ERROR;
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int cmd_dev_selftests_result_show(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct nlattr *test_attr;
+	struct dl *dl = data;
+	int avail = 0;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_SELFTESTS_INFO])
+		return MNL_CB_ERROR;
+
+	mnl_attr_for_each_nested(test_attr,
+				 tb[DEVLINK_ATTR_SELFTESTS_INFO]) {
+		struct nlattr *nla_value[DEVLINK_ATTR_MAX + 1] = {};
+		uint8_t test_res;
+		int test_id;
+		int err;
+
+		err = mnl_attr_parse_nested(test_attr,
+					    selftests_result_attr_cb, nla_value);
+		if (err != MNL_CB_OK)
+			return MNL_CB_ERROR;
+
+		if (!nla_value[DEVLINK_SELFTEST_ATTR_TEST_ID] ||
+		    !nla_value[DEVLINK_SELFTEST_ATTR_TEST_STATUS])
+			return MNL_CB_ERROR;
+
+		if (!avail) {
+			__pr_out_handle_start(dl, tb, true, false);
+			__pr_out_indent_inc();
+			avail = 1;
+			if (!dl->json_output)
+				__pr_out_newline();
+		}
+
+		test_id = mnl_attr_get_u32(nla_value[DEVLINK_SELFTEST_ATTR_TEST_ID]);
+		test_res = mnl_attr_get_u8(nla_value[DEVLINK_SELFTEST_ATTR_TEST_STATUS]);
+
+		check_indent_newline(dl);
+		print_string_name_value(devlink_get_selftests_name(test_id),
+					selftest_result_to_str(test_res));
+		if (!dl->json_output)
+			__pr_out_newline();
+	}
+
+	if (avail) {
+		__pr_out_indent_dec();
+		pr_out_handle_end(dl);
+	}
+
+	return MNL_CB_OK;
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
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SELFTESTS);
+	if (err)
+		return err;
+
+	if (!(dl->opts.present & DL_OPT_SELFTESTS))
+		dl_selftests_put(nlh, &dl->opts);
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
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_LIST, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "selftests");
+	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_selftests_show_tests, dl);
+	pr_out_section_end(dl);
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
@@ -3928,6 +4217,9 @@ static int cmd_dev(struct dl *dl)
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


--0000000000006d8f8005e40e65a0
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMz0TNzvsDr/ws20u3EAnqBFv6R7gBsgL5mN
WiyBwEdKMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcxODA2
MjI0NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQBvfvfnizyTHaji9qtHX+kBjr6KfawvizA8wWmvBCW6nqhnfy0Fd+QX
XB5j3h7XMMZMROxsIHJRFlhxwkoCkV1T7jk3NLB54ElFDiiFSH8FVbSBlYcskZEoAXoxo46h0hPG
kPO7/dGcATAmog90fvKFIEfY1e0f6WAKeAW57JvMht8wW7rh+p/svXRSEpldBIwZK7264q+EqMH6
6Hb4bWTCXBuAXDdmRzwORPg5tPtj03H5YH2oqpbONLiIjyW1CtUmGmII4l7qi57w/PfgxQs/2Yty
Mh6Trx0/HAJJGCTZIggnI0/ipkaifWlCVnUIKqbOBp/tMQx8bB9sL2TVKJ0U
--0000000000006d8f8005e40e65a0--
